#!/usr/bin/env python3
"""Fdy 契约哨兵（CI 口径）。

只做「确定性、零假阳性」的仓库级不变量检查，覆盖四条：

  1. 平台分支哨兵 —— 全库不得出现 `os(macOS)` / `canImport(AppKit)`
  2. 零全局符号   —— 不得声明运算符 / precedencegroup / 顶层自由函数
  3. 五零         —— `as!` / `try!` / 隐式解包 / `unsafeBitCast`·`Unmanaged` / `main.sync`
  4. 文档卫生     —— README.md / CHANGELOG.md 不得出现 `docs/` 路径

权威实现是本机 `.build/structprobe/` 下的只读扫描器（16 类，按约定不入库）；
本脚本是 CI 侧的**近似口径**，只覆盖上面这几条能靠词法判定的，不作 16 类全量替代。

用法：python3 .github/scripts/check_contracts.py [仓库根目录]
退出码：0 = 全部通过；1 = 有违反。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

SOURCES = "Sources"
DOC_FILES = ("README.md", "CHANGELOG.md")


def strip_comments_and_strings(text: str) -> str:
    """把注释与字符串字面量替换成等长空白（保留换行），便于后续行号对齐。

    注释里写「禁止 as!」不该被算成违反；字符串里的 `try!` 同理。
    """
    out: list[str] = []
    i, n = 0, len(text)
    while i < n:
        ch = text[i]
        # 行注释
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                out.append(" ")
                i += 1
            continue
        # 块注释（Swift 支持嵌套）
        if ch == "/" and i + 1 < n and text[i + 1] == "*":
            depth = 1
            out.append("  ")
            i += 2
            while i < n and depth:
                if text.startswith("/*", i):
                    depth += 1
                    out.append("  ")
                    i += 2
                elif text.startswith("*/", i):
                    depth -= 1
                    out.append("  ")
                    i += 2
                else:
                    out.append("\n" if text[i] == "\n" else " ")
                    i += 1
            continue
        # 三引号字符串
        if text.startswith('"""', i):
            out.append("   ")
            i += 3
            while i < n and not text.startswith('"""', i):
                if text[i] == "\\" and i + 1 < n:
                    out.append("  ")
                    i += 2
                else:
                    out.append("\n" if text[i] == "\n" else " ")
                    i += 1
            out.append("   ")
            i += 3
            continue
        # 普通字符串
        if ch == '"':
            out.append(" ")
            i += 1
            while i < n and text[i] != '"':
                if text[i] == "\\" and i + 1 < n:
                    out.append("  ")
                    i += 2
                else:
                    out.append("\n" if text[i] == "\n" else " ")
                    i += 1
            out.append(" ")
            i += 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


# 每条规则：(名称, 编译后的正则, 说明)
CODE_RULES = [
    ("平台分支", re.compile(r"\bos\(macOS\)|\bcanImport\(AppKit\)"), "平台面已收窄为 iOS-only，重新引入须单编验证"),
    ("全局运算符", re.compile(r"(?m)^(?:infix|prefix|postfix)\s+operator\b"), "零全局符号：不得声明运算符"),
    ("precedencegroup", re.compile(r"(?m)^precedencegroup\b"), "零全局符号：不得声明优先级组"),
    ("顶层函数", re.compile(r"(?m)^func\s"), "零全局符号：不得有顶层自由函数"),
    ("强转 as!", re.compile(r"\bas!"), "五零：禁止 as!"),
    ("强制 try!", re.compile(r"\btry!"), "五零：禁止 try!"),
    (
        "隐式解包",
        re.compile(r"\b(?:var|let)\s+\w+\s*:\s*[A-Za-z_][A-Za-z0-9_.<>\[\]]*\s*!(?!=)"),
        "五零：禁止隐式解包类型声明",
    ),
    ("unsafeBitCast/Unmanaged", re.compile(r"\bunsafeBitCast\b|\bUnmanaged\b"), "五零：禁止 unsafeBitCast / Unmanaged"),
    ("main.sync", re.compile(r"DispatchQueue\.main\.sync\b"), "五零：禁止主队列同步等待"),
]

DOC_RULE = re.compile(r"(?:^|[\s(\[`\"'])docs/")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    src = root / SOURCES
    swift_files = sorted(src.rglob("*.swift"))

    if not swift_files:
        print(f"::error::未在 {src} 下找到任何 .swift 文件")
        return 1

    print(f"扫描范围：{src.relative_to(root)}/**/*.swift —— {len(swift_files)} 个文件\n")

    violations: list[str] = []

    # 读盘 + 解析只做一遍，9 条规则共用同一份结果。
    # 放进规则循环内层会让每个文件被重复读盘 9 次 —— 沙箱 / 网络盘上 read_text 比解析
    # 贵三个数量级（实测 72ms vs 0.24ms），脚本会从 ~20s 劣化到 ~3min。
    prepared: list[tuple[Path, list[str], list[str]]] = []
    for path in swift_files:
        raw = path.read_text(encoding="utf-8")
        prepared.append((path, strip_comments_and_strings(raw).splitlines(), raw.splitlines()))

    for name, pattern, why in CODE_RULES:
        hits: list[str] = []
        for path, stripped_lines, raw_lines in prepared:
            for lineno, line in enumerate(stripped_lines, 1):
                if pattern.search(line):
                    rel = path.relative_to(root)
                    snippet = raw_lines[lineno - 1].strip() if lineno <= len(raw_lines) else ""
                    hits.append(f"  {rel}:{lineno}: {snippet}")
        status = "PASS" if not hits else "FAIL"
        print(f"[{status}] {name} —— 命中 {len(hits)} 处（{why}）")
        for line in hits:
            print(line)
        violations += hits

    doc_hits: list[str] = []
    for name in DOC_FILES:
        path = root / name
        if not path.exists():
            continue
        for lineno, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if DOC_RULE.search(line):
                doc_hits.append(f"  {name}:{lineno}: {line.strip()}")
    status = "PASS" if not doc_hits else "FAIL"
    print(f"\n[{status}] 文档卫生 —— README/CHANGELOG 不得出现 docs 路径，命中 {len(doc_hits)} 处")
    for line in doc_hits:
        print(line)
    violations += doc_hits

    print()
    if violations:
        print(f"::error::契约检查未通过，共 {len(violations)} 处违反")
        return 1
    print("契约检查全部通过")
    return 0


if __name__ == "__main__":
    sys.exit(main())
