extends Node

var target_spawn_name: String = ""
var current_save_data: Dictionary = {}

func save_game(slot_id: int) -> void:
	var tico = get_tree().get_first_node_in_group("Player")
	
	var current_room = get_tree().current_scene.scene_file_path
	current_save_data["current_scene"] = current_room
	
	if tico != null:
		current_save_data["tico_x"] = tico.global_position.x
		current_save_data["tico_y"] = tico.global_positon.y
		current_save_data["current_animation"] = tico.get_node("AnimatedSprite2D").animation
		#eventually we'll add this: current_save_data["outfit"] = tico.current_outfit
	
	var save_path = "user://save_slot_" + str(slot_id) + ".save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_string(JSON.stringify(current_save_data))
	file.close()
	
	print("Success! Saved the game with live data to: ", save_path)
	print("Save Data: ", current_save_data)
