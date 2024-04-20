#SingleInstance Force
#NoEnv

; TBTimer v1.0
; Please respect the license, thank you
; Save the script as "UTF-8 BOM" format to prevent corrupted letters
; Compile the app with U32/U64 flavor of base binary

DetectHiddenWindows, Off
DetectHiddenText, Off
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetTitleMatchMode, 1
WS_VISIBLE := 0x10000000
timerState := 0
currentTime := 0
idleDelay := 10000
refreshText := "Get Window List"
errorString := "Cannot find the window!"
winListC := []
targetHWID := ""
mstr := ""
lang := 0
idleString := "In idle state"
activeString := "Window is active"
noFocusString := "Window not in view"
readyString := "Ready"

Gui +Delimiter`n
Menu Tray, Icon, shell32.dll, 250
Menu, tray, Tip, TB Timer v1.0
Gui -MinimizeBox -MaximizeBox +AlwaysOnTop +ToolWindow 
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s20
Gui Add, Text, hTimerText vTimerText1 x8 y8 w281 h33 +0x200 +Border +0x1, 00:00:00
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x0 y48 w301 h2 +0x10
Gui Add, Text, hWndhTxtTargetWindow2 vTxtTargetWindow2 x8 y56 w144 h23 +0x200 +0x1, Target Window
Gui Add, DropDownList, vDDLItems gchangeTarget x8 y80 w280 +0x1 -AltSubmit, << Update/Mise à jour >>
Gui Add, Button, hWndhBtnStartStop vBtnStartText gStartStop x8 y112 w80 h23, &Start
Gui Add, CheckBox, hWndhChkStrictMode vChkStrictMode gtoggleStrictMode x98 y144 w108 h23, Strict Mode
Gui Add, StatusBar, hWndhSb vSb, Ready
Gui Add, Radio, hWndhRadEnglish vRadEnglish gchangeLangEN x160 y56 w59 h23 +Checked, English
Gui Add, Radio, hWndhRadFrancois2 vRadFrancois2 gchangeLangFR x224 y56 w64 h23, Français
Gui Add, Button, hWndhBtnReset2 vBtnReset2 gresetTimer x104 y112 w90 h23, &Reset
Gui Font
Gui Font, s7
Gui Add, Button, hWndhBtnCopyTime3 vBtnCopyTime3 gcopyTime x8 y144 w80 h23, &Copy Time
Gui Font
Gui Add, Button, hWndhBtnExit4 vBtnExit4 gQuitApp x208 y112 w80 h23 +0x1, &Exit
Gui Add, Text, x208 y144 w81 h23 +0x200 +0x1, By Torchbearer

Gui Show, w297 h198, TB Timer v1.0
Return

GetWindowsByStyle(p_style,p_delim="|") {
    winListC := [0]
    l_out := refreshText
    WinGet, l_array, List
    Loop, %l_array% {
        WinGet, l_tmp, Style, % "ahk_id "l_array%A_Index%
        If (l_tmp & p_style)
            {
                WinGetTitle, l_tmp, % "ahk_id "l_array%A_Index%
                vz := l_tmp
                cz := winListC.Push(vz)
                l_out .= ( l_out="" ? "" : p_delim ) l_tmp
        }
    }
    Return l_out
}

StartStop:
    timerState := !timerState
    if (timerState) {
        SetTimer, checkWin, 1000
        if (lang == 0) {
        GuiControl,, BtnStartText, Stop
        } else {
            GuiControl,, BtnStartText, Arrêt
        }
    } else {
        SetTimer, checkWin, Off
        if (lang == 0) {
        GuiControl,, BtnStartText, Start
        } else {
            GuiControl,, BtnStartText, Commencer
        }
    }
return

refreshTargets:
    winlist := % GetWindowsByStyle(WS_VISIBLE, "`n")
    GuiControl,, DDLItems, %winlist%
    Gui, Submit, NoHide
return

changeTarget:
    Gui, Submit, NoHide
    GuiControlGet, dz,, DDLItems
    if (dz == "<< Update/Mise à jour >>") {
        gosub, refreshTargets
    } else {
        targetHWID := dz
    }
Return

toggleStrictMode:
    GuiControlGet, strictMode,, ChkStrictMode
    if (strictMode == 1) {
        idleDelay := 5000
    } else {
        idleDelay := 10000
    }
Return

changeLangEN:
    GuiControl,, TxtTargetWindow2, Target Window
    if (timerState == 1) {
        GuiControl,, BtnStartText, Stop
    } else {
        GuiControl,, BtnStartText, Start
    }
    GuiControl,, ChkStrictMode, Strict Mode
    GuiControl,, BtnReset2, Reset
    GuiControl,, BtnCopyTime3, Copy Time
    GuiControl,, BtnExit4, Exit
    refreshText := "Get Window List"
    errorString := "Cannot find the window!"
    lang := 0
    idleString := "In idle state"
    activeString := "Window is active"
    readyString := "Ready"
    noFocusString := "Window not in view"
    if (timerState == 1) {
        GuiControl,, BtnStartText, Stop
    } else {
        GuiControl,, BtnStartText, Start
    }
    if (currentTime == 0) {
        GuiControl,, Sb, %readyString%
    }
Return

changeLangFR:
    GuiControl,, TxtTargetWindow2, Surveillez cette fenêtre
    GuiControl,, ChkStrictMode, Comptage Strict
    GuiControl,, BtnReset2, Réinitialiser
    GuiControl,, BtnCopyTime3, Durée de Copie
    GuiControl,, BtnExit4, Fermer
    refreshText := "Obtenez la liste des fenêtres"
    errorString := "Je ne trouve pas cette fenêtre!"
    lang := 1
    idleString := "En attente d'activité"
    activeString := "Une activité est détectée"
    readyString := "Prêt, j'attends"
    noFocusString := "Fenêtre non visible"
    if (timerState == 1) {
        GuiControl,, BtnStartText, Arrêt
    } else {
        GuiControl,, BtnStartText, Commencer
    }
    if (currentTime == 0) {
        GuiControl,, Sb, %readyString%
    }
Return

milli2hms(milli, ByRef hours=0, ByRef mins=0, ByRef secs=0, secPercision=0)
{
  SetFormat, FLOAT, 0.%secPercision%
  milli /= 1000.0
  secs := mod(milli, 60)
  SetFormat, FLOAT, 0.0
  milli //= 60
  mins := mod(milli, 60)
  hours := milli //60
  secs := (StrLen(secs)=1 ? "0" : "") secs
  mins := (StrLen(mins)=1 ? "0" : "") mins
  hours := (StrLen(hours)=1 ? "0" : "") hours
  return hours . ":" . mins . ":" . secs
}

checkWin:
    WinGet, uid, ID, %targetHWID%
    mstr := milli2hms(currentTime)
    if (uid == "") {
        GuiControl,, Sb, %errorString%
        return
    } else {
        zid := WinExist("A")
        if (zid == uid) {
            if (A_TimeIdlePhysical > idleDelay) {
                GuiControl,, Sb, %idleString%
                currentTime += 0
            } else if ((A_TimeIdlePhysical < idleDelay) && (zid == uid)) {
                currentTime += 1000
                GuiControl,, TimerText1, %mstr%
                GuiControl,, Sb, %activeString%
            }
        } else {
            GuiControl,, Sb, %noFocusString%
            currentTime += 0
        }
    }
return

resetTimer:
    currentTime := 0
    timerState := 0
    GuiControl,,TimerText1, 00:00:00
    if (lang == 0) {
        GuiControl,, BtnStartText, Start
    } else {
        GuiControl,, BtnStartText, Commencer
    }
    GuiControl,, Sb, %readyString%
    SetTimer, checkWin, Off
    Gui, Submit, NoHide
Return

copyTime:
    GuiControlGet, mt,, TimerText1
    clipboard := mt
Return

GuiEscape:
GuiClose:
QuitApp:
    ExitApp
