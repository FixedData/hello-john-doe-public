local ffi = require("ffi")
--im not even sure if this works on mac
function onEndSong()
    runTimer('k', 1)
end

function onTimerCompleted(t)
    if t == 'k' then awesome() end
end

function awesome()
    ffi.cdef([[
    enum{
    COLOR_REF = 0x00000000
    };

    typedef void* HWND;

    typedef int BOOL;

    typedef unsigned char BYTE;
    typedef unsigned long DWORD;
    typedef DWORD COLORREF;

    HWND GetActiveWindow();

    long SetWindowLongA(HWND hWnd, int nIndex, long dwNewLong);

    BOOL SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha, DWORD dwFlags);
    ]])
    local hwnd = ffi.C.GetActiveWindow()
    if ffi.C.SetWindowLongA(hwnd, -20, 0x00080000) ~= 0 then
        ffi.C.SetLayeredWindowAttributes(hwnd, ffi.C.COLOR_REF, 0, 0x00000001) 
    end
end