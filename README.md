# TBTimer
An AutoHotKey application designed to measure time spent inside a specific window

## How to use
This application is very simple to use, it takes more time to type this out than to actually use the program.
1. Run the script or the precompiled EXE (**ALWAYS check the hash before using**)
2. From the drop-down list below the language selector and "Target Window" text, select the first option called `<< Update/Mise à jour >>`
3. It will be populated with the list of windows it saw at that moment, pick one that matches your required window's name
4. Select whether or not to be more strict about the idle time (Strict Mode toggle changes the idle detection threshold from 10 seconds to 5 seconds)
5. Press Start then start using your application normally
6. When you're finished, press Stop
7. Press "Copy Time" to copy the currently displayed time
8. Press Reset to initialize the application state back to 0
9. Press Exit to quit, or you can just close the window

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
