extends Control

@onready var score = $Box/ScoreLabel

@export var cow_scene: PackedScene
@export var entity_scene: PackedScene
@export var volleyball_scene: PackedScene

@export var full_heart: Texture2D
@export var broken_heart: Texture2D

@onready var heart1 = $HBoxContainer/Heart1
@onready var heart2 = $HBoxContainer/Heart2
@onready var heart3 = $HBoxContainer/Heart3

@onready var congrats_board =  $CongratulationsBoard
@onready var board_animation = $CongratulationsBoard/AnimationPlayer

@onready var lose_screen = $LoseScreen
@onready var wake_up_btn = $LoseScreen/WakeUp
@onready var panic_timer = $LoseScreen/PanicTimer
@onready var warnings = $LoseScreen/WarningContainer

@onready var bg = $BG
@onready var tico = $Tico
@onready var bg_base_pos = bg.position
@onready var tico_base_pos = tico.position

signal game_over
signal night_won

var total_vbs_spawned: int = 0
var clicks_needed_to_wake: int = 0
var current_clicks: int = 0
var is_game_over: bool = false
var active_warnings_count: int = 0
var is_world_glitching: bool = false

var vbs_counted: int = 0
var entities_counted: int = 0
var hearts: int = 3
var items_left_on_screen: int = 0

func _ready() -> void:
	start_night()

func start_night() -> void:
	randomize()
	
	var total_appearances = randi_range(6, 13)
	
	items_left_on_screen = total_appearances
	vbs_counted = 0
	hearts = 3
	total_vbs_spawned = 0
	is_game_over = false
	self.modulate = Color(1, 1, 1)
	
	update_ui()
	
	for i in range(total_appearances):
		if is_game_over:
			break
		
		spawn_item()
		await get_tree().create_timer(1.5).timeout
		
	if not is_game_over:
		await get_tree().create_timer(2.0).timeout
		if hearts > 0 and vbs_counted == total_vbs_spawned:
			print("You defeated the nightmare...Time to get up!")
			night_won.emit()
			game_over_win()
		else:
			print("You missed a volleyball! Nightmares win.")
			game_over_lose()

func spawn_item() -> void:
	var random_type = randi() % 3
	var item_instance
	
	if random_type == 0:
		item_instance = cow_scene.instantiate()
		item_instance.pressed.connect(_on_cow_pressed.bind(item_instance))
	elif random_type == 1:
		item_instance = entity_scene.instantiate()
		item_instance.pressed.connect(_on_entity_pressed.bind(item_instance))
	else:
		item_instance = volleyball_scene.instantiate()
		item_instance.pressed.connect(_on_volleyball_pressed.bind(item_instance))
		total_vbs_spawned += 1
	
	var anim = item_instance.get_node("AnimationPlayer")
	var random_speed = randf_range(1.5, 3.0)
	anim.play("jump_animation", -1.0, random_speed)
	$SpawnLayer.add_child(item_instance)

func _on_cow_pressed(clicked_item: Node) -> void:
	clicked_item.queue_free()
	check_remaining_items()

func _on_entity_pressed(clicked_item: Node) -> void:
	hearts -= 1
	clicked_item.queue_free()
	
	if hearts == 2:
		heart3.texture = broken_heart
	elif hearts == 1:
		heart2.texture = broken_heart
	else:
		heart1.texture = broken_heart
		print("Wake up, Tico...GET UP NOW!")
		game_over.emit()
		game_over_lose()
	
	update_ui()
	check_remaining_items()

func _on_volleyball_pressed(clicked_item: Node) -> void:
	vbs_counted += 1
	update_ui()
	clicked_item.queue_free()
	check_remaining_items()

func check_remaining_items() -> void:
	items_left_on_screen -= 1

func update_ui() -> void:
	score.text = "Volleyballs: " + str(vbs_counted)

func game_over_win() -> void:
	print("Game Over Win Func has started")
	
	congrats_board.visible = true
	congrats_board.position.y = -800.0
	
	var drop_tween = create_tween()
	drop_tween.tween_property(congrats_board, "position:y", -250.0, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await drop_tween.finished
	
	board_animation.play("swaying_board", 0.5)
	#TODO: add transition to dayttime here
	
func game_over_lose() -> void:
	if is_game_over:
		return
	
	is_game_over = true
	print("Game Over Lose Func Started")
	
	lose_screen.visible = true
	clicks_needed_to_wake = randi_range(8,15)
	current_clicks = 0
	
	var all_warnings = warnings.get_children()
	active_warnings_count = 0
	for w in all_warnings:
		w.visible = false
		
	if all_warnings.size() > 0:
		all_warnings[0].visible = true
		active_warnings_count = 1
		
	is_world_glitching = true
	self.modulate = Color(0.7, 0.2, 0.2) # Bloody red screen tint
	
	await get_tree().create_timer(1.0).timeout 
	
	for i in range(1, 4):
		if i < all_warnings.size():
			all_warnings[i].visible = true
			active_warnings_count = 4
			
	await get_tree().create_timer(0.8).timeout
	
	for i in range(4, all_warnings.size()):
		all_warnings[i].visible = true
		
	active_warnings_count = all_warnings.size()
	
	panic_timer.start(5)

func _process(_delta: float) -> void:
	if is_game_over and lose_screen.visible:
		
		var all_warnings = warnings.get_children()
		for i in range(active_warnings_count):
			var warning = all_warnings[i]
			warning.visible = randf() > 0.1 
			warning.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
			
		if is_world_glitching:
			var random_offset = Vector2(randf_range(-8.0, 8.0), randf_range(-8.0, 8.0))
			
			bg.position = bg_base_pos + random_offset
			tico.position = tico_base_pos + random_offset
			
			tico.visible = randf() > 0.15

func _on_wake_up_pressed() -> void:
	current_clicks += 1
	
	var click_tween = create_tween()
	wake_up_btn.scale = Vector2(0.9, 0.9) 
	click_tween.tween_property(wake_up_btn, "scale", Vector2(1.0, 1.0), 0.1)
	
	if current_clicks >= clicks_needed_to_wake:
		panic_timer.stop()
		print("TICO WOKE UP!")
		#TODO: transition to next morning

func _on_panic_timer_timeout() -> void:
	wake_up_btn.disabled = true
	print("TOO LATE! The nightmare is here!")

#----------Exit Button----------
func _on_exit_btn_mouse_entered() -> void:
	var hover = create_tween()
	hover.tween_property($CongratulationsBoard/ExitBtn, "scale", Vector2(1.1, 1.1), 0.1)

func _on_exit_btn_mouse_exited() -> void:
	var exit = create_tween()
	exit.tween_property($CongratulationsBoard/ExitBtn, "scale", Vector2(1.0, 1.0), 0.1)
	
func _on_exit_btn_pressed() -> void:
	print("loading to next day...")
	#TransitionScreen.transition_to_scene("")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_exit_btn_pressed()
