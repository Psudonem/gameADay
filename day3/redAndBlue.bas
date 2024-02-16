$Resize:Stretch
_Title "Red and Blue"
' setup screen
Screen _NewImage(500, 500, 32)
titleScr = _NewImage(500, 500, 32)

blockSprRed = _NewImage(40, 100, 32)
blockSprRedPlayer = _NewImage(40, 100, 32)

blockSprBlue = _NewImage(40, 100, 32)
blockSprBluePlayer = _NewImage(40, 100, 32)

gamePlayHUD = _NewImage(500, 500, 32)


pauseScr = _NewImage(500, 500, 32)

gameOverScr = _NewImage(500, 500, 32)

score = 0
lives = 0
Cls

red = _RGB(255, 0, 0)
redB = _RGB(255, 200, 200)
blue = _RGB(0, 0, 255)
blueB = _RGB(200, 200, 255)

ttlMax = 50
ttl = ttlMax

_Dest titleScr
Color _RGB(255, 255, 0)
_PrintString (170, 250), "RED AND BLUE"
_PrintString (50, 400), "<SPACE> to play.  <left> and <right> to control paddle."
_PrintString (50, 432), "<p> to pause!"

Color _RGB(100, 255, 100)
_PrintString (8, 8), "K. Jasey... 15-16 Feb 2024"

_Dest pauseScr
_PrintString (8, 8), "GAME PAUSED!!!"
_PrintString (8, 32), "press p again to unpause"

' RED BLOCKS=====================
_Dest blockSprRed
Line (1, 1)-(39, 99), red, BF

_Dest blockSprRedPlayer
Line (1, 1)-(39, 99), red, BF
For i = 0 To 4
    Line (1 + i, 1 + i)-(39 - i, 99 - i), redB, B
Next i
' ===============================


' BLUE BLOCKS====================
_Dest blockSprBlue
Line (1, 1)-(39, 99), blue, BF

_Dest blockSprBluePlayer
Line (1, 1)-(39, 99), blue, BF
For i = 0 To 4
    Line (1 + i, 1 + i)-(39 - i, 99 - i), blueB, B
Next i
' ===============================

GoSub renderHud


_Dest gameOverScr
Print "game over dude!!!!"

_Dest 0
_DisplayOrder _Hardware

titleScrH = _CopyImage(titleScr, 33)
_FreeImage titleScr

'scrh = _CopyImage(scr, 33)
'_FreeImage scr

blockSprRedH = _CopyImage(blockSprRed, 33)
_FreeImage blockSprRed

blockSprRedPlayerH = _CopyImage(blockSprRedPlayer, 33)
_FreeImage blockSprRedPlayer

blockSprBlueH = _CopyImage(blockSprBlue, 33)
_FreeImage blockSprBlue

blockSprBluePlayerH = _CopyImage(blockSprBluePlayer, 33)
_FreeImage blockSprBluePlayer


pauseScrH = _CopyImage(pauseScr, 33)
_FreeImage pauseScr

gameOverScrH = _CopyImage(gameOverScr, 33)
_FreeImage gameOverScr
Type actor
    x As Integer
    y As Integer
    w As Integer
    h As Integer
    vspeed As Integer
    hspeed As Integer
    state As Integer
End Type
Dim p As actor
p.w = 40
p.h = 100
Dim enemies(100) As actor
For i = 0 To 99
    enemies(i).state = -1
    enemies(i).w = 40
    enemies(i).h = 100
Next i
nextBlankEnem = 0


gameState = 0
Do

    ' _PutImage (p.x, p.y), paddleSprH


    Select Case gameState
        Case 0:
            GoSub titleDraw
            GoSub titleLogic


            'title screen
        Case 1:
            GoSub gamePlayDraw
            GoSub gamePlayLogic
        Case 2:
            GoSub pauseDraw
            GoSub pauseLogic
            ' pause
        Case 3:
            GoSub gameOverDraw
            GoSub gameOverLogic
            ' display game over screen
        Case 4:
            GoSub retryGameDraw
            GoSub retryGameLogic
    End Select

    _Display
    _Limit 60
Loop

renderHud:
gamePlayHUD = _NewImage(500, 500, 32)
_Dest gamePlayHUD
Print "SCORE:", score, "LIVES:", lives
_Dest 0
gamePlayHUDh = _CopyImage(gamePlayHUD, 33)
_FreeImage gamePlayHUD

Return

retryGameLogic:
Return
retryGameDraw:
Return





gamePlayDraw:
GoSub renderHud
_PutImage , gamePlayHUDh
Select Case p.state
    Case 0:
        _PutImage (p.x, p.y), blockSprRedPlayerH
    Case 1:
        _PutImage (p.x, p.y), blockSprBluePlayerH
End Select

For i = 0 To 99
    Select Case enemies(i).state
        Case 0:
            _PutImage (enemies(i).x, enemies(i).y), blockSprRedH
        Case 1:
            _PutImage (enemies(i).x, enemies(i).y), blockSprBluePlayerH
    End Select

Next i


Return

gamePlayLogic:

pause = _KeyDown(80)
If pause Then gameState = 2
pause = _KeyDown(112)
If pause Then gameState = 2

k = _KeyHit
Select Case k
    Case 19200:
        p.x = p.x - 20
    Case 19712:
        p.x = p.x + 20
End Select

For i = 0 To 99

    If enemies(i).state > -1 Then
        If (actorCollideSpecial(p, enemies(i)) = 1) Then
            enemies(i).state = -1
            score = score + 1
            If p.state = 0 Then
                p.state = 1
            Else
                p.state = 0
            End If
        End If


        enemies(i).y = enemies(i).y + 1
        If enemies(i).y > 449 Then
            enemies(i).state = -1
        End If
    End If

Next i


GoSub spawnRandomBlock

Return

spawnRandomBlock:
ttl = ttl - 1
If ttl = 0 Then
    If (enemies(nextBlankEnem).state = -1) Then
        enemies(nextBlankEnem).x = Int(Rnd * 20) * 15 + 10
        enemies(nextBlankEnem).y = 0
        enemies(nextBlankEnem).state = Int(Rnd * 2)
    End If
    nextBlankEnem = nextBlankEnem + 1
    If nextBlankEnem > 99 Then nextBlankEnem = 0

    ttl = ttlMax
End If

Return

pauseDraw:
_PutImage , pauseScrH
Return

pauseLogic:

k = _KeyHit
Select Case k
    Case 80:
        gameState = 1
    Case 112:
        gameState = 1
End Select
Return

gameOverDraw:
_PutImage , gameOverScrH
Return
gameOverLogic:
ttl = ttl - 1
If ttl = 0 Then gameState = 0
Return

titleLogic:
k$ = InKey$
If k$ = " " Then
    gameState = 1
    GoSub gameSetup
End If
Return

titleDraw:
_PutImage (0, 0), titleScrH
Return

gameSetup:
score = 0
lives = 4
p.x = 0
p.y = 400
p.state = 0 ' red
Return


Function actorCollideSpecial (a1 As actor, a2 As actor)
    o = 0
    l1x = a1.x
    l2x = a2.x
    r1x = a1.x + a1.w
    r2x = a2.x + a2.w
    l1y = a1.y
    l2y = a2.y
    r1y = a1.y + a1.y
    r2y = a2.y + a2.y

    If l1x >= l2x And l1x <= r2x And l1y >= l2y And l1y <= r2y Then
        o = 1
    End If
    If (l1x >= l2x And l1x <= r2x And r1y >= l2y And r1y <= r2y) Then
        o = 1
    End If

    If (r1x >= l2x And r1x <= r2x And r1y >= l2y And r1y <= r2y) Then
        o = 1
    End If '// bottom right corner in other

    If (r1x >= l2x And r1x <= r2x And l1y >= l2y And l1y <= r2y) Then
        o = 1
    End If '// top right corner in other r1x, l1y


    If (l1x > l2x And r1x < r2x And l1y < l2y And r1y > r2y) Then o = 1




    actorCollideSpecial = o
End Function

