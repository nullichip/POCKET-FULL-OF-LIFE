extends Node2D

func _on_to_path_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.is_interacting = true 
		if body.last_direction < 0:
			body.animated_sprite.play("idle_twd_left")
		else:
			body.animated_sprite.play("idle_twd_right")
			
		GameManager.target_spawn_name = "FromPlayground"
		await TransitionScreen.transition_to_scene("res://scenes/places/park_path.tscn")
