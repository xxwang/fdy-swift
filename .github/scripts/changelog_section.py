#!/usr/bin/env python3
"""从 CHANGELOG.md 里抽出指定版本的段落，供 GitHub Release 正文使用。

本库的版本标题形如 `## [0.3.0] - 2026-09-21`。抽出的正文从该标题的下一行起，
到下一条 `## `（二级标题）前止，并剥掉首尾空行与行尾空白。

用法：python3 .github/scripts/changelog_section.py <版本号> [CHANGELOG 路径]
退出码：0 = 抽到；1 = CHANGELOG 里没有该版本（发版前必须先补条目）。
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

HEADING = re.compile(r"^##\s+\[(?P<version>[^\]]+)\]")


def extract(text: str, version: str) -> str | None:
    lines = text.splitlines()
    start = None
    for index, line in enumerate(lines):
        match = HEADING.match(line)
        if match and match.group("version") == version:
            start = index + 1
            break
    if start is None:
        return None

    body: list[str] = []
    for line in lines[start:]:
        if line.startswith("## "):
            break
        body.append(line.rstrip())

    while body and not body[0]:
        body.pop(0)
    while body and not body[-1]:
        body.pop()
    return "\n".join(body)


def main() -> int:
    if len(sys.argv) < 2:
        print("用法：changelog_section.py <版本号> [CHANGELOG 路径]", file=sys.stderr)
        return 1

    version = sys.argv[1]
    path = Path(sys.argv[2] if len(sys.argv) > 2 else "CHANGELOG.md")
    if not path.exists():
        print(f"::error::{path} 不存在", file=sys.stderr)
        return 1

    body = extract(path.read_text(encoding="utf-8"), version)
    if not body:
        print(f"::error::CHANGELOG.md 里找不到 [{version}] 段落，先在主线补条目再打 tag", file=sys.stderr)
        return 1

    sys.stdout.write(body + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
