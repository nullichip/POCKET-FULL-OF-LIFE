extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func transition_to_scene(target_scene_path: String, wait_time: float = 3.0) -> void:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	if wait_time > 0.0:
		await get_tree().create_timer(wait_time).timeout
	
	get_tree().change_scene_to_file(target_scene_path)
	
	animation_player.play("fade_to_normal")
