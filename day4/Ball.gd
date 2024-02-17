extends CharacterBody2D

var win_size : Vector2

const START_SPEED: int = 500
const ACCEL : int = 50
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6

func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	#randomize position and direction
	position.x = win_size.x /2
	position.y = randi_range(200,win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()


func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider 
	if collision:
		collider = collision.get_collider()
		# if ball hits paddle
		if collider == $"../Player" or collider == $"../CPU":
			if collider == $"../Player":
				$"../Player/PlayerHitSound".play()
			else:
				$"../CPU/CPUHitSound".play()
			speed+=ACCEL
			dir = new_direction(collider)
		else:
			dir = dir.bounce(collision.get_normal())
			$"../Borders/WallBounceSound".play()
			
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1,-1].pick_random()
	new_dir.y = randf_range(-1,1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	#flip x cordinate
	new_dir.x =sign(dir.x)*-1
	
	new_dir.y = (dist / (collider.p_height / 2 )) * MAX_Y_VECTOR
	
	return new_dir.normalized()
	
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
#	move_and_collide(dir*speed*delta)
	
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
