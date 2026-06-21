extends Area2D

@export var dialogue_text: String = "Dialoge text"
@export var is_looking_left: bool = false

var is_player_near = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if is_player_near == true:
			var tico = get_tree().get_nodes_in_group("Player")[0]
			tico.face_door()
			
			await DialogueManager.show_dialogue(dialogue_text)
			tico.is_interacting = false
			
			if tico.last_direction < 0:
				tico.animated_sprite.play("idle_twd_left")
			else:
				tico.animated_sprite.play("idle_twd_right")
