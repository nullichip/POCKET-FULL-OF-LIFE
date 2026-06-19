extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func show_dialogue(dialogue_text: String) -> void:
	var dialogue_label = $Panel/Label
	
	$Panel.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dialogue_label.text = dialogue_text
	dialogue_label.visible_ratio = 0.0
	
	visible = true
	
	var type_time = dialogue_text.length() * 0.05
	
	var type_tween = create_tween()
	type_tween.tween_property(dialogue_label, "visible_ratio", 1.0, type_time)
	
	await type_tween.finished
	await get_tree().create_timer(3.0).timeout
	
	$AnimationPlayer.play("fade_out_dialogue")
	await $AnimationPlayer.animation_finished
	
	visible = false
