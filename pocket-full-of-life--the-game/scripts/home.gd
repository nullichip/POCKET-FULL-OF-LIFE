extends Node2D

func _ready() -> void:
	if GameManager.target_spawn_name != "":
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		
		if spawn_marker:
			$Tico.global_position = spawn_marker.global_position
			
			await get_tree().physics_frame
			
			$Tico.walk_into_room(GameManager.last_known_direction)
		else:
			print("ERROR: Godot could not find a node named ", GameManager.target_spawn_name)
			
		GameManager.target_spawn_name = ""

func _on_home_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		GameManager.last_known_direction = int(body.last_direction)
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
		
		GameManager.target_spawn_name = "FromInsidetheHouse"
		await TransitionScreen.transition_to_scene("res://scenes/places/outsideofthe_house.tscn")

func _on_living_room_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		GameManager.last_known_direction = int(body.last_direction)
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
		
		GameManager.target_spawn_name = "HomeHallwaySpawn"
		await TransitionScreen.transition_to_scene("res://scenes/places/living_room.tscn")
