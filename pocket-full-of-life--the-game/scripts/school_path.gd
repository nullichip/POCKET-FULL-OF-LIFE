extends Node2D

func _ready() -> void:
	if GameManager.target_spawn_name != "":
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		
		if spawn_marker:
			$PixelTico.global_position = spawn_marker.global_position
			
			if GameManager.target_spawn_name == "FromInsideSchool":
				$PixelTico.walk_to_newpath("backward")
			elif GameManager.target_spawn_name == "FromCrossRoad":
				$PixelTico.walk_to_newpath("backward")
			else:
				$PixelTico.walk_to_newpath("backward")
				
		else:
			print("ERROR: Godot could not find a node named ", GameManager.target_spawn_name)
			
		GameManager.target_spawn_name = ""
	
func _on_school_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.last_known_direction = 1 
		
		GameManager.target_spawn_name = "FromSchoolEnterance"
		await TransitionScreen.transition_to_scene("res://scenes/places/school_hall_1.tscn", 2.0)

func _on_cross_road_enterance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromSchool"
		await TransitionScreen.transition_to_scene("res://scenes/places/crosspath.tscn")
