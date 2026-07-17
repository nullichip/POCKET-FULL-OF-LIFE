extends Control

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
	pass
	#this will be where players save their progress

#------------------------Mirror------------------------
func _on_mirror_pressed() -> void:
	pass 
	#this is to transition to the changing room minigame
