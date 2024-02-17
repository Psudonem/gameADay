extends StaticBody2D

var win_height : int
var p_height : int

var win_width: int
var p_width : int



# Called when the node enters the scene tree for the first time.
func _ready():
	win_height  = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	win_width = get_viewport_rect().size.x
	p_width = $ColorRect.get_size().x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= (get_parent().PADDLE_SPEED/2) * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += (get_parent().PADDLE_SPEED/2) * delta
		
	# limit movement to window
	position.y = clamp(position.y, p_height/2, win_height - p_height/2)
	position.x = clamp(position.x, p_width/2, win_width - p_width/2)
