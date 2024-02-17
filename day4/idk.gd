extends Sprite2D

var score := [0,0]# player,cpu
const PADDLE_SPEED :int = 500


func _on_ball_timer_timeout():
	$Ball.new_ball()


func _on_score_left_body_entered(body):
	score[1]+=1
	$Hud/CPUScore.text = str(score[1])
	$ScoreLeft/CPUScoreSound.play()
	$BallTimer.start()
	
func _on_score_right_body_entered(body):
	score[0]+=1
	$Hud/PlayerScore.text = str(score[0])
	$ScoreRight/PlayerScoreSound.play()
	$BallTimer.start()
