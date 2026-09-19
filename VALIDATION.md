# IrisHub v2 Validation

Validated on 2026-09-19 in the packaging sandbox.

- `python build.py`: passed
- `python tools/validate.py`: passed
- `node --check website/app.js`: passed
- Source and distribution SHA-256: identical
- Forbidden `--` marker in Luau source/tests/examples: zero occurrences
- Required project files: present
- Local website references: resolved
- Stale `v1.0.0` markers in project docs/code: none
- Lua 5.4 parser pass: passed after translating the single Luau `+=` expression used only for syntax compatibility in the sandbox

The parser pass is a static syntax sanity check, not a replacement for Roblox Studio execution. Roblox-specific rendering, input and layout behavior still requires a Studio play-test.
