extends Node2D

func _ready() -> void:
	if GameManager.target_spawn_name != "":
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		
		if spawn_marker:
			$PixelTico.global_position = spawn_marker.global_position
			
			if GameManager.target_spawn_name == "FromCrossRoad":
				$PixelTico.walk_to_newpath("right") 
			elif GameManager.target_spawn_name == "FromPath": 
				$PixelTico.walk_to_newpath("left") 
			else:
				$PixelTico.walk_to_newpath("left")
				
		else:
			print("ERROR: Godot could not find a node named ", GameManager.target_spawn_name)
			
		GameManager.target_spawn_name = ""

func _on_cross_road_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromPark"
		await TransitionScreen.transition_to_scene("res://scenes/places/crosspath.tscn")


func _on_play_ground_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromPath"
		await TransitionScreen.transition_to_scene("res://scenes/places/park.tscn")
