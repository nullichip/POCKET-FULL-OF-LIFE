extends Control

var is_journal_open: bool = false
const JOURNAL_SCENE = preload("res://scenes/journal.tscn")
const DRESS_UP_SCENE = preload("res://scenes/dress_up.tscn")
const COUNTING_VBS_SCENE = preload("res://scenes/counting_volleyballs.tscn")
var active_journal: Node = null

@onready var lamp_light = $PointLight2D
@onready var eyes = $ScaryEyes

func _ready() -> void:
	update_room_state()

#------------------------BEDROOM------------------------
func _on_bed_pressed() -> void:
	var player_said_yes = await ConfirmationMenu.ask_question("GO TO SLEEP?")
	
	if player_said_yes:
		await TransitionScreen.transition_to_scene("res://scenes/counting_volleyballs.tscn", 6.0)
		
		var counting_vbs_game = COUNTING_VBS_SCENE.instantiate()
		add_child(counting_vbs_game)
		
		await counting_vbs_game.game_over
		
		#loading morning scene
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

#----------------------Lamp----------------------
func _on_lamp_pressed() -> void:
	lamp_light.enabled = not lamp_light.enabled
	update_room_state()

func update_room_state() -> void:
	if lamp_light.enabled == true:
		eyes.visible = false
	else:
		eyes.visible = true
