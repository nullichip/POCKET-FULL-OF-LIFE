extends Node2D

func _ready() -> void:
	if GameManager.target_spawn_name != "":
		var spawn_marker = get_node_or_null(GameManager.target_spawn_name)
		
		if spawn_marker:
			$PixelTico.global_position = spawn_marker.global_position
			
			if GameManager.target_spawn_name == "FromSchool":
				$PixelTico.walk_to_newpath("backward") 
			elif GameManager.target_spawn_name == "FromPark":
				$PixelTico.walk_to_newpath("left") 
			elif GameManager.target_spawn_name == "From???":
				$PixelTico.walk_to_newpath("right") 
			elif GameManager.target_spawn_name == "FromPath":
				$PixelTico.walk_to_newpath("forward") 
			else:
				print("WARNING: Marker name didn't match any directions!")
				$PixelTico.walk_to_newpath("forward")
				
		else:
			print("ERROR: Godot could not find a node named ", GameManager.target_spawn_name)
			
		GameManager.target_spawn_name = ""

func _on_school_path_enter_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromCrossRoad"
		await TransitionScreen.transition_to_scene("res://scenes/places/school_path.tscn")

func _on_enter_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromCrossPath"
		await TransitionScreen.transition_to_scene("res://scenes/places/unknown_area.tscn")
	
func _on_path_enter_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromCrossPath"
		await TransitionScreen.transition_to_scene("res://scenes/places/path.tscn")

func _on_park_enter_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.velocity = Vector2.ZERO
		
		GameManager.target_spawn_name = "FromCrossRoad"
		await TransitionScreen.transition_to_scene("res://scenes/places/park_path.tscn")
