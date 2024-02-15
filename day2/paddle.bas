$Resize:Stretch
_Title "Paddle Ball"
' setup screen
Screen _NewImage(500, 500, 32)
titleScr = _NewImage(500, 500, 32)

paddleSpr = _NewImage(40, 100, 32)

Cls

_Dest titleScr
Color _RGB(255, 255, 0)
_PrintString (170, 250), "PADDLE BALL!"


_Dest paddleSpr
Line (1, 1)-(39, 99), _RGB(200, 200, 0), BF


_Dest scr
Line (1, 1)-(400, 400), _RGB(255, 255, 255)

_Dest 0
_DisplayOrder _Hardware

titleScrH = _CopyImage(titleScr, 33)
_FreeImage titleScr

'scrh = _CopyImage(scr, 33)
'_FreeImage scr

paddleSprH = _CopyImage(paddleSpr, 33)
_FreeImage paddleSpr


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
ball.w = 30
ball.h = 30
ball.vspeed = 4
ball.hspeed = 4


gameState = 0
Do




    ' _PutImage (p.x, p.y), paddleSprH


    Select Case gameState
        Case 0:
            GoSub titleLogic
            GoSub titleDraw

            'title screen
        Case 1:
            ' gameplay loop
        Case 2:
            ' pause
        Case 3:
            ' display game over screen
    End Select

    ' player controls
    _Display




    _Limit 60
Loop


titleLogic:
Return
titleDraw:
_PutImage (0, 0), titleScrH
Return
