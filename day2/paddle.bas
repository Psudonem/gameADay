$Resize:Stretch
_Title "Paddle Ball"
' setup screen
Screen _NewImage(500, 500, 32)
titleScr = _NewImage(500, 500, 32)

paddleSpr = _NewImage(40, 100, 32)

ballSpr = _NewImage(20, 20, 32)

pauseScr = _NewImage(500, 500, 32)

gameOverScr = _NewImage(500, 500, 32)
Cls

_Dest titleScr
Color _RGB(255, 255, 0)
_PrintString (170, 250), "PADDLE BALL!"
_PrintString (50, 400), "<SPACE> to play.  <up> and <down> to control paddle."
_PrintString (50, 432), "<p> to pause!"

Color _RGB(100, 255, 100)
_PrintString (8, 8), "K. Jasey... 14-15 Feb 2024)"

_Dest pauseScr
_PrintString (8, 8), "GAME PAUSED!!!"
_PrintString (8, 32), "press p again to unpause"

_Dest paddleSpr
Line (1, 1)-(39, 99), _RGB(100, 100, 0), BF
Line (1, 1)-(39, 99), _RGB(255, 255, 180), B
Line (2, 2)-(38, 98), _RGB(255, 255, 255), B
Line (3, 3)-(37, 97), _RGB(255, 255, 180), B

_Dest ballSpr
Line (1, 1)-(19, 19), _RGB(0, 255, 255), BF

_Dest gameOverScr
Print "game over dude!!!!"

_Dest 0
_DisplayOrder _Hardware

titleScrH = _CopyImage(titleScr, 33)
_FreeImage titleScr

'scrh = _CopyImage(scr, 33)
'_FreeImage scr

paddleSprH = _CopyImage(paddleSpr, 33)
_FreeImage paddleSpr

ballSprH = _CopyImage(ballSpr, 33)
_FreeImage ballSpr

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
p.x = 10
p.y = 20
p.w = 40
p.h = 100
p.state = 0

Dim ball As actor
ball.x = 250
ball.y = 250
ball.w = 20
ball.h = 20
ball.vspeed = 4
ball.hspeed = 4


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
    End Select

    _Display
    _Limit 60
Loop


gamePlayDraw:
_PutImage (p.x, p.y), paddleSprH
_PutImage (ball.x, ball.y), ballSprH
Return

gamePlayLogic:

up = _KeyDown(18432)
down = _KeyDown(20480)
pause = _KeyDown(80)
If pause Then gameState = 2
pause = _KeyDown(112)
If pause Then gameState = 2


If up Then p.y = p.y - 3
If down Then p.y = p.y + 3

If (actorCollideSpecial(p, ball, ball.hspeed, 0) = 1) Then
    ball.hspeed = ball.hspeed * -1
End If

If (actorCollideSpecial(p, ball, 0, ball.vspeed) = 1) Then
    ball.vspeed = ball.vspeed * -1
End If



If (ball.x + ball.hspeed > 500) Then ball.hspeed = ball.hspeed * -1
If (ball.y + ball.vspeed > 500) Then ball.vspeed = ball.vspeed * -1
If (ball.y + ball.vspeed < 0) Then ball.vspeed = ball.vspeed * -1
If (ball.x + ball.hspeed < 0) Then
    gameState = 3
    ttl = 120
    Sound 49, 2
End If


ball.x = ball.x + ball.hspeed
ball.y = ball.y + ball.vspeed
Return

pauseDraw:
_PutImage , pauseScrH
_PutImage (p.x, p.y), paddleSprH
_PutImage (ball.x, ball.y), ballSprH
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
    ball.x = 250
    ball.y = 250
    ball.w = 20
    ball.h = 20
    ball.vspeed = 1
    ball.hspeed = 2
End If
Return

titleDraw:
_PutImage (0, 0), titleScrH
Return



Function actorCollideSpecial (a1 As actor, a2 As actor, a2hspeed As Integer, a2vspeed As Integer)
    o = 0
    l1x = a1.x
    l2x = a2.x + a2hspeed
    r1x = a1.x + a1.w
    r2x = a2.x + a2.w + a2hspeed
    l1y = a1.y
    l2y = a2.y + a2vspeed
    r1y = a1.y + a1.h
    r2y = a2.y + a2.h + a2vspeed

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

