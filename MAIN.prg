''''''''''''''''''''''''''''
'''' LEPLJENJE ROKAVICK ''''
''''''''''''''''''''''''''''
'''' IT - ELEKTRONIKA ''''''
''''''''''''''''''''''''''''

Global Integer total
Global Integer ZPOINT
Global Integer ZPREPICK
Global Integer ZPOSTPICK
Global Integer workqueLen
Global Integer i
Global Integer a(0)
Global Integer waitCount
Global Integer notwaitCount
Global Integer workqueNum
Global Boolean STOPCYCLE
Global Integer glovesFound

Function MAIN
  workqueNum = 1

  
  STOPCYCLE = 0






  Trap 1, Sw(StopSw) Xqt END ''

  
  ''''' IZBIRA DOZE '''''''''
  Call SELECT_PROGRAM
  
  
  ''''' SPUSCANJE/DVIGANJE - PARAMETRI'''''''  
  Call PICK_N_PLACE_PARAM
  
  '''''''' START '''''''''
  Call START
  
  ''''''''''''' GLAVNA ZANKA '''''''''''''''''
  Do
    Print "######################################"
    
    WorkQue_Remove workqueNum, All
    VGet pickGloveGeo.Glove.AllRobotXYU, workqueNum
    VGet pickGloveGeo.Glove.NumberFound, glovesFound
    Redim a(glovesFound)
    
     
    
    '''''''VIBRIRANJE V PRIMERU, DA NI ROKAVICK''''
    Do
      If (WorkQue_Len(workqueNum)) < 1 Then
    	On vibrator, 0.2
    	Wait 0.4
    	VRun pickGloveGeo
        VGet pickGloveGeo.Glove.AllRobotXYU, workqueNum
        VGet pickGloveGeo.Glove.NumberFound, glovesFound
        Redim a(glovesFound)
      Else
    	Exit Do
    
      EndIf
    Loop
    '''''''''''''''''''''''''''''''''''''''''''''''
    Print "'''''''''''''''''''''''''''''''''''''''"
    Print "GlovesFound: ", glovesFound
    For i = 0 To (glovesFound - 1)
    	Print WorkQue_Get(workqueNum, (i)) :Z(ZPOINT)
    Next
    Print "'''''''''''''''''''''''''''''''''''''''"
    '''''''''' POBIRANJE ''''''''''''''''''''''''''
    For i = 0 To (glovesFound - 1)
      If STOPCYCLE Then
      	GoTo cyclestop
      EndIf
      
      'ZPOINT = WorkQue_UserData(workqueNum, (i))
      Go WorkQue_Get(workqueNum, (i)) :Z(ZPOINT) :U(0.0)
      On vacuum
      JTran 3, ZPREPICK
      JTran 3, ZPOSTPICK
      Print WorkQue_Get(workqueNum, (i)) :Z(ZPOINT)
      Print i
      ''''' PRIMER ZADNJE ROKAVICE '''''''''''''''''''''''''''''
      If i = (glovesFound - 1) And Not STOPCYCLE Then
        Xqt VIBRATE
      EndIf
    
      Go PREPOINT
      

      If i = (glovesFound - 1) And Not STOPCYCLE Then
        Xqt VRUN_CAM
      EndIf
      ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''    
      '''''''''''''''''''''''''ODLAGANJE''''''''''''''''''''''''
      If Sw(dovoljenje_odl_rok) And Sw(sonda_tlak) Then
        Print "1"
        Go PLACEPOINT
        Off vacuum
        Go PREPOINT
        Xqt GLOVE_ON
        notwaitCount = notwaitCount + 1
      ''''''ODLAGANJE - ROKAVICKE NI NA SESALKI'''''
      ElseIf Sw(dovoljenje_odl_rok) And Not Sw(sonda_tlak) Then
        Print "2"
        Go PREPOINT
        Off vacuum
      '''''''''' PRIMER STOPCYCLE '''''''
      ElseIf STOPCYCLE Then
        Print "3"
        Go PLACEPOINT
        Off vacuum
        Go PREPOINT
        Xqt GLOVE_ON
        notwaitCount = notwaitCount + 1
      ''''''ODLAGANJE - CAKA DOVOLJENJE ZA ODLAGANJE'''''
      Else
        Print "4"
        
        
        Wait Sw(dovoljenje_odl_rok) Or Sw(StopSw)
        'If TW Then
        '	GoTo cyclestop
        'EndIf        
        Wait 1
        If STOPCYCLE Then
		  GoTo cyclestop
        EndIf
        
        If Sw(sonda_tlak) Then
          Go PLACEPOINT
          Off vacuum
          Go PREPOINT
          Xqt GLOVE_ON
          waitCount = waitCount + 1
        EndIf
      EndIf
      '''''''''''''''''''''''''''''''''''''''''''''''''''   
    Next i
    '''''''''''''''''''''''''''''''''''''''''''''''
    Print "######################################"
  Loop

'''''''''''''''ZAKLJUCEK CIKLA '''''''''''''''''


CYCLESTOP:

Print " wait count is : ", waitCount
Print " not wait count is : ", notwaitCount
Print "Stop Cycle"
total = waitCount + notwaitCount
Print "total count : ", total
Print total / ElapsedTime
Print total / ElapsedTime * 60
Power Low
Go CYCLESTOP_PLACE
Off rokavica_prilepljena
Off vacuum
Off vibrator
Home

Fend









