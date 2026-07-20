extends Control

var is_journal_open: bool = false
const JOURNAL_SCENE = preload("res://scenes/journal.tscn")
const DRESS_UP_SCENE = preload("res://scenes/dress_up.tscn")
var active_journal: Node = null

#------------------------BEDROOM------------------------
func _on_bed_pressed() -> void:
	var player_said_yes = await ConfirmationMenu.ask_question("GO TO SLEEP?")
	
	if player_said_yes:
		#await TransitionScreen.transition_to_scene("", 6.0)
		await get_tree().create_timer(6.00).timeout
		print("Change the scene to daytime bedroom")
	else:
		print("Player cancled. Staying Up...")
#------------------------Exit------------------------
func _on_exit_pressed() -> void:
	var player_said_yes = await ConfirmationMenu.ask_question("LEAVE BEDROOM?")
	
	if player_said_yes:
		GameManager.target_spawn_name = "BedroomSpawn"
		await TransitionScreen.transition_to_scene("res://scenes/home.tscn", 0.0)
	else:
		print("Player cancled.")

#------------------------Posters------------------------
func _on_poster_pressed() -> void:
	await DialogueManager.show_dialogue("I hope I get as good as them one day...")

#------------------------Journal------------------------
func _on_journal_pressed() -> void:
	$journal.disabled = true
	
	var clicked_journal: Tween = create_tween()
	
	if is_journal_open == false:
		is_journal_open = true
		clicked_journal.tween_property($journal, "position:y", $journal.position.y - 100, 0.3)
		
		active_journal = JOURNAL_SCENE.instantiate()
		add_child(active_journal)
		
	elif is_journal_open == true:
		is_journal_open = false
		clicked_journal.tween_property($journal, "position:y", $journal.position.y + 100, 0.3)
		
		if active_journal != null:
			active_journal.queue_free()
			active_journal = null
		await clicked_journal.finished
	$journal.disabled = false 

#------------------------Mirror------------------------
func _on_mirror_pressed() -> void:
	var dress_up_menu = DRESS_UP_SCENE.instantiate()
	add_child(dress_up_menu)
