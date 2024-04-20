# TBTimer
An AutoHotKey application designed to measure time spent inside a specific window

## Limitations
- This can only see titles of windows that are not "widget" windows (appears in Alt-Tab picker)
- This can only find windows with the **name** you selected from the list (duplicate windows are not filtered well)
- Windows with no size, as well as fully transparent and invisible windows (e.g. KakaoTalk hidden windows, messenger popup handlers, etc.) are also detected
- If the window title changes, this can't track that, and report that it can't find that window anymore (this might have issues with programs like Photoshop)
- Of course, Windows only

# Known Issues
- DPI scaling causes the app layout to get messed up
- If a blank name is selected, the app will not function
- If window switching happens in less than 1 second, this will not detect that event
