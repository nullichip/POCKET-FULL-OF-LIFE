extends CanvasLayer

signal choice_selection(is_yes: bool)

func ask_question(question_text: String) -> bool:
	print("Menu opened, starting animation...")
	$Fader/Label.text = question_text
	$Fader.modulate.a = 0.0
	show()
	
	$AnimationPlayer.play("fade_in_confirmation_menu")
	await $AnimationPlayer.animation_finished
	
	print("Animation finished. Now waiting for button click...")
	var result = await choice_selection
	
	print("Signal recieved! Result: ", result)
	$AnimationPlayer.play("fade_out_confirmation_menu")
	await $AnimationPlayer.animation_finished
	
	hide()
	return result

func _on_yes_btn_pressed() -> void:
	choice_selection.emit(true)

func _on_no_btn_pressed() -> void:
	choice_selection.emit(false)

func _on_yes_btn_mouse_entered() -> void:
	var hover = create_tween()
	hover.tween_property($Fader/YesBtn, "scale", Vector2(1.1, 1.1), 0.1)

func _on_no_btn_mouse_entered() -> void:
	var hover = create_tween()
	hover.tween_property($Fader/NoBtn, "scale", Vector2(1.1, 1.1), 0.1)

func _on_yes_btn_mouse_exited() -> void:
	var hover_out = create_tween()
	hover_out.tween_property($Fader/YesBtn, "scale", Vector2(1.0, 1.0), 0.1)
	
func _on_no_btn_mouse_exited() -> void:
	var hover_out = create_tween()
	hover_out.tween_property($Fader/NoBtn, "scale", Vector2(1.0, 1.0), 0.1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_no_btn_pressed()
