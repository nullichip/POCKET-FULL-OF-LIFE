extends CanvasLayer

func show_dialogue(dialogue_text: String) -> void:
	# 1. Update the path to your new NinePatchRect!
	var dialogue_label = $Panel/Label
	
	# 2. Wake the CanvasLayer up so we can actually see the animation
	show() 
	
	# 3. Prep the text for the typewriter effect
	dialogue_label.text = dialogue_text
	dialogue_label.visible_ratio = 0.0
	
	# 4. Fade in the background art
	$AnimationPlayer.play("fade_in_dialogue")
	await $AnimationPlayer.animation_finished

	# 5. The typewriter text tween
	var type_time = dialogue_text.length() * 0.05
	var type_tween = create_tween()
	type_tween.tween_property(dialogue_label, "visible_ratio", 1.0, type_time)
	
	# Wait for the typing to finish, then let the player read it for 2 seconds
	await type_tween.finished
	await get_tree().create_timer(2.0).timeout
	
	# 6. Fade everything out
	$AnimationPlayer.play("fade_out_dialogue")
	await $AnimationPlayer.animation_finished
	
	# 7. Put the CanvasLayer back to sleep until the next painting
	hide()
