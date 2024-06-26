' Test - Gamepad
'
Option Explicit
Option Base 0
Option Default Float

Dim integer running = 1, ch
Dim string s$

' Gamepad-related variables
' Types:
'   0=not in use, 1=keyboard, 2=mouse, 128=ps4, 129=ps3, 130=SNES/Generic, 131=Xbox
Dim integer gpad.ch = 0, gpad.type = 0, gpad.changed = 0
Dim integer gpad.data(6), gpad._intDetect = 0

initGamePad 131
If gpad.ch = 0 Then
  Print "No gamepad found"
  End
EndIf

Do While running
  ' Update gamepad data and if new, print values out
  If updateGamepad() Then
     Math V_print gpad.data()
     checkGamepad
  EndIf

  ' Check for escape, which aborts program
  ch = Asc(LCase$(Inkey$))
  If ch = 27 Then running = 0
  Pause 20
Loop
End

' ----------------------------------------------------------------------------
Sub initGamepad _type
  ' Look for gamepad `_type` and initialize it, if available
  Local integer i, j
  gpad.ch = 0
  gpad.type = 0
  Math Set 0, gpad.data()
  For i=1 To 4
    j = MM.Info(USB i)
    If j = _type Then
      Print "Gamepad type="+Str$(_type)+" found."
      gpad.ch = i
      gpad.type = _type
      Device gamepad interrupt enable i, _cb_gamepad
      Exit Sub
    EndIf
  Next
End Sub

Function updateGamepad()
  ' Keeps gamepad data up to date (call frequently)
  Static integer v(6)
  If gpad.type < 128 Then updateGamepad = 0 : Exit Sub : EndIf

  ' Read gamepad sticks etc
  gpad.data(0) = DEVICE(gamepad gpad.ch, lx)
  gpad.data(1) = DEVICE(gamepad gpad.ch, ly)
  gpad.data(2) = DEVICE(gamepad gpad.ch, rx)
  gpad.data(3) = DEVICE(gamepad gpad.ch, ry)
  gpad.data(4) = DEVICE(gamepad gpad.ch, l)
  gpad.data(5) = DEVICE(gamepad gpad.ch, r)

  ' Check if any stick value as substantially changed
  Math C_Sub v(), gpad.data(), v() : v(6) = 0
  gpad.changed = gpad._intDetect Or Abs(Math(Sum v())) > 2
  gpad._intDetect = 0
  updateGamepad = gpad.changed
  Math Scale gpad.data(), 1, v()
End Function

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
' &H0001 := R1
' &H0002 := Options/Start
' &H0004 := PS/Home
' &H0008 := Share/Select
' &H0010 := L1
' &H0020 := pad, down
' &H0040 := pad, right
' &H0080 := pad, up
' &H0100 := pad, left
' &H0200 := R2 pressed, value in `gpad.data(5)`
' &H0400 := Triangle
' &H0800 := Circle
' &H1000 := Square
' &H2000 := Cross
' &H4000 := L2 pressed, value in `gpad.data(4)`
' &H8000 := touchpad pressed

Sub checkGamepad
  Local string s$ = ""
  If gpad.data(6) And &H0400 Then s$ = s$ +"Triangle "
  If gpad.data(6) And &H1000 Then s$ = s$ +"Square "
  If gpad.data(6) And &H0800 Then s$ = s$ +"Circle "
  If gpad.data(6) And &H2000 Then s$ = s$ +"Cross "
  If gpad.data(6) And &H0010 Then s$ = s$ +"L1 "
  If gpad.data(6) And &H0001 Then s$ = s$ +"R1 "
  If gpad.data(6) And &H0002 Then s$ = s$ +"Start "
  If gpad.data(6) And &H4000 Then s$ = s$ +"L2 ("+Str$(gpad.data(4))+") "
  If gpad.data(6) And &H0200 Then s$ = s$ +"L2 ("+Str$(gpad.data(5))+") "
  If gpad.data(6) And &H0008 Then s$ = s$ +"Share "
  If gpad.data(6) And &H0004 Then s$ = s$ +"PS "
  If gpad.data(6) And &H0100 Then s$ = s$ +"< "
  If gpad.data(6) And &H0040 Then s$ = s$ +"> "
  If gpad.data(6) And &H0080 Then s$ = s$ +"^ "
  If gpad.data(6) And &H0020 Then s$ = s$ +"v "
  If gpad.data(6) And &H8000 Then s$ = s$ +"Touchpad "
  Print "&B"+Bin$(gpad.data(6), 32)""
  Print s$
End Sub

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Sub _cb_gamepad
  ' Interrupt callback for gamepad
  If gpad.type < 128 Then Exit Sub
  gpad.data(6) = DEVICE(gamepad gpad.ch, b)
  gpad._intDetect = 1
End Sub

' ----------------------------------------------------------------------------
