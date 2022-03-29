; ### Global Setup
SetTitleMatchMode, 2 ; Match any title containing
SendMode Input ; Allows for instant keypresses if no other keyboard hooks are installed
SetDefaultMouseSpeed, 0 ; Move the mouse instantly, if mouse clicks are missed, maybe set to the default of 2
CoordMode Mouse, Screen
waitMQFocus := 20 ; Sets how long we wait for MagicQ to focus from minimised, set to -1 to let AHK decide, 20 is faster though and often works

GroupAdd, CaptureAndMQ, ahk_exe mqqt.exe
GroupAdd, CaptureAndMQ, Capture

SysGet, MonitorCount, MonitorCount
SysGet, Mon1, Monitorworkarea, 1 

; ### Helper Functions
; Clicks on a spot and then gracefully returns the mouse back to where it was
QClick(x, y)
{
	MouseGetPos, ox, oy
	Send {Click %x% %y%}
	MouseMove, %ox%, %oy% , 0
}

; Forcefully clicks on a spot in MagicQ and then gracefully returns the mouse back to where it was
QClickMQ(x, y)
{
	WinActivate ahk_exe mqqt.exe
	if waitMQFocus > 0
		Sleep, waitMQFocus
	else
		WinWaitActive ahk_exe mqqt.exe
	
	
	MouseGetPos, ox, oy
	Send {Click %x% %y%}
	MouseMove, %ox%, %oy% , 0
	
	WinActivate Capture	
}

; ### Globals
isSingle := true
isSplit := false
activePlaybackGo := -1

; ### Keybinds
#IfWinActive ahk_exe mqqt.exe

	^F1::
	MsgBox, 64, MagicQ Shortcuts Quick Reference, Ctrl+F1  - This menu`nF1-F3  - Layouts`nF5-F8  - Grp`,Pos`,Col`,Beam`nF9  - Locate`nF10  - Highlight`nF11  - All/Single`nF12  - Fan`nDel  - Clear`nCtrl+0-9  - Select GO playback`nCaps+Space  - GO`nCaps+Ctrl+Space  - Pause/Back`nTab  - Switch between MagicQ and Capture`nShift+Tab  - Split/Unsplit MagicQ and Capture`nDel  - Clear`nCtrl+Del  - Remove`nEnd  - Set`nIns/Home/PgUp  - Include`,Update`,Record
	return
	
	F1::
	QClick(1677, 926)  ;Layout 1
	return

	F2::
	QClick(1707, 926)  ;Layout 2
	return

	F3::
	QClick(1739, 926)  ;Layout 3
	return


	F5::
	QClick(1677, 875)  ;Group
	return

	F6::
	QClick(1677, 895)  ;Pos
	return      

	F7::        
	QClick(1707, 895)  ;Col
	return      

	F8::        
	QClick(1739, 895)  ;Beam
	return
	
	
	F9::
	QClick(1856, 404)  ;Locate
	return

	F10::
	QClick(1856, 439)  ;Highlight
	return      

	F11:: ;All/Single
	if isSingle
	{
		QClick(1890, 474)  ; All
		isSingle := false
	} else {
		QClick(1890, 439)  ; Single
		isSingle := true
	}
	return      

	F12::    
	QClick(1856, 474)  ;Fan
	return
	
	
	Delete::
	QClick(1739, 768)  ;Clear
	return
	
	^Delete::
	QClick(1829, 768)  ;Remove
	return
	
	
	End::
	QClick(1798, 796)  ;Set
	return
	
	Insert::
	QClick(1828, 796)  ;Include
	return
	
	Home::
	QClick(1858, 796)  ;Update
	return
	
	PGUP::
	QClick(1889, 796)  ;Record
	return
	
	
	
	; Set the playback the GO button acts on
	^1::
	activePlaybackGo := 156
	return
	^2::
	activePlaybackGo := 306
	return
	^3::
	activePlaybackGo := 460
	return
	^4::
	activePlaybackGo := 611
	return
	^5::
	activePlaybackGo := 762
	return
	^6::
	activePlaybackGo := 917
	return
	^7::
	activePlaybackGo := 1068
	return
	^8::
	activePlaybackGo := 1221
	return
	^9::
	activePlaybackGo := 1374
	return
	^0::
	activePlaybackGo := 1526
	return
	^-::
	activePlaybackGo := 1613
	return
	
#If WinActive("ahk_exe mqqt.exe") and GetKeyState("CapsLock","T")
	; CapsLock is show mode
	Space::
	QClick(activePlaybackGo, 870)  ; Play on active playback
	return
	
	Right::
	QClick(activePlaybackGo, 870)  ; Play on active playback
	return
	
	^Space::
	QClick(activePlaybackGo, 892)  ; Pause on active playback
	return
	
	+Space::
	QClick(activePlaybackGo, 892)  ; Pause on active playback
	return
	
	Left::
	QClick(activePlaybackGo, 892)  ; Pause on active playback
	return
	
	
#If WinActive("Capture") and GetKeyState("CapsLock","T")
	; CapsLock is show mode
	Space::
	QClickMQ(activePlaybackGo, 870)  ; Play on active playback
	return
	
	Right::
	QClickMQ(activePlaybackGo, 870)  ; Play on active playback
	return
	
	^Space::
	QClickMQ(activePlaybackGo, 892)  ; Pause on active playback
	return
	
	+Space::
	QClickMQ(activePlaybackGo, 892)  ; Pause on active playback
	return
	
	Left::
	QClickMQ(activePlaybackGo, 892)  ; Pause on active playback
	return
	

#IfWinActive ahk_group CaptureAndMQ

	Tab::
		if WinActive("ahk_exe mqqt.exe")
			WinActivate Capture
		else
			WinActivate ahk_exe mqqt.exe
		return
		
	+Tab::
		if isSplit
		{
			; Maximise both
			WinMove,Capture,,mon1left, mon1top,mon1right,mon1bottom
			WinMove,ahk_exe mqqt.exe,,mon1left, mon1top,mon1right,mon1bottom
			isSplit := false
		} else
		{
			; Place Capture to the right
			WinMove,Capture,,mon1left+(mon1right-mon1left)/2-8, mon1top,(mon1right-mon1left)/2+16,mon1bottom+8
			; Place MQ to the left
			WinMove,ahk_exe mqqt.exe,,mon1left-8, mon1top,(mon1right-mon1left)/2+16,mon1bottom+8
			isSplit := true
		}
		return
		