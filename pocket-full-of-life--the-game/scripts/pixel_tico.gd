extends CharacterBody2D

const SPEED = 250.0

@onready var animated_sprite = $AnimatedSprite2D
var last_direction: String = "down"

func _physics_process(delta: float) -> void:
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
