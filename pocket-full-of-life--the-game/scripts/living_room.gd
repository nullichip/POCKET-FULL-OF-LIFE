extends Node2D

func _ready() -> void:
	print("--- DEBUG START ---")
	print("1. The GameManager memory says: '", GameManager.target_spawn_name, "'")
	
	if GameManager.target_spawn_name != "":
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		print("2. Did Godot find the marker? ", spawn_marker)
		
		if spawn_marker:
			print("3. Teleporting Tico!")
			$Tico.global_position = spawn_marker.global_position
			$Tico.walk_into_room(GameManager.last_known_direction)
		else:
			print("ERROR: Could not find a node named ", GameManager.target_spawn_name)
			
		GameManager.target_spawn_name = ""
		
	print("--- DEBUG END ---")

func _on_enter_kitchen_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		GameManager.last_known_direction = int(body.last_direction)
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
		
		GameManager.target_spawn_name = "FromLivingRoom"
		await TransitionScreen.transition_to_scene("res://scenes/places/kitchen.tscn")


func _on_enter_home_hallway_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		GameManager.last_known_direction = int(body.last_direction)
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		GameManager.target_spawn_name = "LivingRoomSpawn"
		await TransitionScreen.transition_to_scene("res://scenes/places/home.tscn")
