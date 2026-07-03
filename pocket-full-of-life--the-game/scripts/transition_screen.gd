extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func transition_to_scene(target_scene_path: String) -> void:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	await get_tree().create_timer(3.00).timeout
	
	get_tree().change_scene_to_file(target_scene_path)
	animation_player.play("fade_to_normal")
