extends CharacterBody2D


const SPEED = 250.0

@onready var animated_sprite = $AnimatedSprite2D
var is_interacting = false
var last_direction = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		if is_interacting == false:
			face_door()
		else:
			is_interacting = false
		return
	
	if Input.is_action_just_pressed("ui_down"):
		if is_interacting == true:
			is_interacting = false
			
			if last_direction < 0:
				animated_sprite.play("idle_twd_left")
			elif last_direction > 0:
				animated_sprite.play("idle_twd_right")
		return
	
	if is_interacting == true:
		move_and_slide()
		return
		
	var direction := Input.get_axis("ui_left", "ui_right")
		
	if direction:
		velocity.x = direction * SPEED
		last_direction = direction
		
		if direction < 0: 
			animated_sprite.play("walk_twd_left")
		elif direction > 0:
			animated_sprite.play("walk_twd_right")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if last_direction < 0:
			animated_sprite.play("idle_twd_left")
		elif last_direction > 0:
			animated_sprite.play("idle_twd_right")

	move_and_slide()

func face_door() -> void:
	is_interacting = true
	velocity.x = 0
	
	if last_direction < 0:
		animated_sprite.play("look_away_twd_left")
	else:
		animated_sprite.play("look_away_twd_right")

func _on_home_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		GameManager.target_spawn_name = "OutsideSpawn"
		await TransitionScreen.transition_to_scene("res://scenes/home.tscn", 3.0)

func _on_kitchen_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		TransitionScreen.transition_to_scene("res://scenes/kitchen.tscn", 0.0)


func _on_hallway_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		GameManager.target_spawn_name = "KitchenSpawn"
		await TransitionScreen.transition_to_scene("res://scenes/home.tscn", 0.0)
