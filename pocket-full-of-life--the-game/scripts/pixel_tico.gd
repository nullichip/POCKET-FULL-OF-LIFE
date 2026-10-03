extends CharacterBody2D

const SPEED = 200.0

@onready var animated_sprite = $AnimatedSprite2D
var last_direction: String = "down"

var is_entering_newpath: bool = false
var autowalk_vector: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_entering_newpath:
		velocity = autowalk_vector * SPEED
		move_and_slide()
		return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	velocity = direction * SPEED
		
	if direction != Vector2.ZERO:
		if direction.x > 0:
			animated_sprite.play("walk_right")
			last_direction = "right"
		elif direction.x < 0:
			animated_sprite.play("walk_left")
			last_direction = "left"
		elif direction.y > 0:
			animated_sprite.play("walk_fwd")
			last_direction = "forward"
		elif direction.y < 0:
			animated_sprite.play("walk_back")
			last_direction = "backward"
	else:
		if last_direction == "right":
			animated_sprite.play("idle_right")
		elif last_direction == "left":
			animated_sprite.play("idle_left")
		elif last_direction == "forward":
			animated_sprite.play("idle_fwd")
		elif last_direction == "backward":
			animated_sprite.play("idle_back")
	move_and_slide()

func walk_to_newpath(dir_string: String) -> void:
	is_entering_newpath = true
	last_direction = dir_string 
	
	if dir_string == "right":
		autowalk_vector = Vector2.RIGHT
		animated_sprite.play("walk_right")
	elif dir_string == "left":
		autowalk_vector = Vector2.LEFT
		animated_sprite.play("walk_left")
	elif dir_string == "forward":
		autowalk_vector = Vector2.DOWN
		animated_sprite.play("walk_fwd")
	elif dir_string == "backward":
		autowalk_vector = Vector2.UP
		animated_sprite.play("walk_back")
	
	await get_tree().create_timer(0.3).timeout
	
	is_entering_newpath = false
	velocity = Vector2.ZERO
	
	if last_direction == "right":
		animated_sprite.play("idle_right")
	elif last_direction == "left":
		animated_sprite.play("idle_left")
	elif last_direction == "forward":
		animated_sprite.play("idle_fwd")
	elif last_direction == "backward":
		animated_sprite.play("idle_back")
	
