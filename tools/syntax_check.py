from pathlib import Path
import ctypes
import sys

ROOT = Path(__file__).resolve().parents[1]
TARGETS = [ROOT / "src" / "IrisHub.luau", ROOT / "examples" / "GitHubLoadstringExample.luau"]
LIB = "/usr/lib/x86_64-linux-gnu/liblua5.4.so.0"


def loadstring_check(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if "--" in text:
        raise AssertionError(f"{path}: forbidden comment marker")
    text = text.replace(
        "rotation += delta * 240; spinner.Rotation = rotation",
        "rotation = rotation + delta * 240; spinner.Rotation = rotation",
    )
    lib = ctypes.CDLL(LIB)
    lib.luaL_newstate.restype = ctypes.c_void_p
    lib.luaL_openlibs.argtypes = [ctypes.c_void_p]
    lib.luaL_loadstring.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
    lib.luaL_loadstring.restype = ctypes.c_int
    lib.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.POINTER(ctypes.c_size_t)]
    lib.lua_tolstring.restype = ctypes.c_char_p
    lib.lua_close.argtypes = [ctypes.c_void_p]

    state = lib.luaL_newstate()
    if not state:
        raise RuntimeError("unable to create Lua validation state")
    try:
        lib.luaL_openlibs(state)
        result = lib.luaL_loadstring(state, text.encode("utf-8"))
        if result != 0:
            length = ctypes.c_size_t()
            message = lib.lua_tolstring(state, -1, ctypes.byref(length))
            detail = message.decode("utf-8", "replace") if message else "unknown parser error"
            raise AssertionError(f"{path}: {detail}")
    finally:
        lib.lua_close(state)


for target in TARGETS:
    loadstring_check(target)
    print(f"syntax ok: {target.relative_to(ROOT)}")
