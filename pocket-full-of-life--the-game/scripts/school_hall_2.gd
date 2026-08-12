extends Node2D

func _ready() -> void:
	print("--- DEBUG START ---")
	print("1. The GameManager memory says: '", GameManager.target_spawn_name, "'")
	
	if GameManager.target_spawn_name != "":
		# Using get_node_or_null so it doesn't crash if it can't find it!
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		print("2. Did Godot find the marker? ", spawn_marker)
		
		if spawn_marker:
			print("3. Teleporting Tico!")
			$Tico.global_position = spawn_marker.global_position
			await get_tree().physics_frame
			print("4. Tico is now at coordinates: ", $Tico.global_position)
		else:
			print("ERROR: Godot could not find a node named ", GameManager.target_spawn_name, " in the Scene Tree!")
			
		GameManager.target_spawn_name = ""
		
	print("--- DEBUG END ---")

func _on_backto_hall_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		GameManager.target_spawn_name = "FromSchoolHall2"
		await TransitionScreen.transition_to_scene("res://scenes/places/school_hall_1.tscn", 0.0)

func _on_to_gym_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
		
		GameManager.target_spawn_name = "FromHall"
		await TransitionScreen.transition_to_scene("res://scenes/places/gymnasium.tscn", 0.0)

func _on_english_room_pressed() -> void:
	shake_item($BackGround/EnglishRoom)

func _on_math_room_pressed() -> void:
	shake_item($BackGround/MathRoom)

func shake_item(target_item: Control) -> void:
	var shake_tween = create_tween()
	var start_pos = target_item.position
	
	var shake_amt = 0.5
	var speed = 0.05
	
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(0, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos, speed)
