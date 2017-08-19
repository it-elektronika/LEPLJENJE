Function SELECT_PROGRAM
  If Sw(program_velika_doza) Then
	PREPOINT = PREPOINT
	PLACEPOINT = PLACEPOINT
  ElseIf Sw(program_srednja_doza) Then
    PREPOINT = PREPOINT_srednja
    PLACEPOINT = srednja_doza
  ElseIf Sw(program_mala_doza) Then
    PREPOINT = PREPOINT_mala
    PLACEPOINT = mala_doza
  EndIf
Fend

