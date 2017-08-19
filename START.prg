Function START
  Motor On
  Power High
  Home
  
 
  If Sw(Servis) = On Then
	Print "Servis on"
	Speed 1
	Print "Speed is: ", Speed
  ElseIf Sw(Servis) = Off Then
    Print "Servis off"
    Speed 90
    Accel 90, 90
    Print "Speed is: ", Speed
  EndIf
  Go PREPOINT
  VRun pickGloveGeo
  
Fend


