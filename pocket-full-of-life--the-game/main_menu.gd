extends Control

@onready var menu_buttons = [$PlayButton, $ChapterButton, $RestartButton, $SettingButton]
@onready var game_title = $GameTitle

@onready var fire = $Fire
var time_passed = 0.0

@onready var glitch_overlay = $GlitchOverlay
@onready var glitch_timer = $GlitchTimer

var base_scale = Vector2(1.0, 1.0)
var base_positions = {}


func _ready() -> void:
	$PlayButton.pressed.connect(_on_play_pressed)
	$ChapterButton.pressed.connect(_on_chapter_pressed)
	$RestartButton.pressed.connect(_on_restart_pressed)
		
	for btn in menu_buttons:
		btn.mouse_entered.connect(animate_button.bind(btn, 1.03))
		btn.mouse_exited.connect(animate_button.bind(btn, 1.0))
		btn.button_down.connect(animate_button.bind(btn, 0.95))
		btn.button_up.connect(animate_button.bind(btn, 1.0))
		
		base_positions[btn] = btn.position
		base_positions[game_title] = game_title.position
		base_positions[fire] = fire.position

func animate_button(btn_node, scale_multiplier) -> void:
	var tween = create_tween()
	tween.tween_property(btn_node, "scale", base_scale * scale_multiplier, 0.1)

func _on_glitch_timer_timeout() -> void:
	glitch_overlay.color.a = randf_range(0.1, 0.5)
	glitch_timer.wait_time = randf_range(0.009, 0.4)
	
func _process(delta: float) -> void:
	for btn in menu_buttons:
		if randi() % 10 == 0:
			btn.position.x = base_positions[btn].x + randf_range(-8.0, 8.0)
			btn.position.y = base_positions[btn].y + randf_range(-3.0, 3.0)
			btn.scale.y = base_scale.y * randf_range(0.75, 1.0)
		else:
			btn.position.x = base_positions[btn].x
			btn.position.y = base_positions[btn].y
			
		if randi() % 10 == 0:
			game_title.position.x = base_positions[game_title].x + randf_range(-16.0, 16.0)
			game_title.position.y = base_positions[game_title].y + randf_range(-8.0, 8.0)
			game_title.scale.y = base_scale.y * randf_range(0.85, 1.1)
		else:
			game_title.position = base_positions[game_title]
			game_title.scale.y = base_scale.y
			
	time_passed += delta
	#the 1.0 is how FAST the fire will sway, the 4.0 is how FAR it will sway
	fire.position.x = base_positions[fire].x + sin(time_passed * 0.05) * 9.0
	fire.modulate.a = randf_range(0.3, 1.1)
	
func _on_play_pressed() -> void:
	TransitionScreen.transition_to_scene("") #TODO: ADD GAME SCENE HERE

func _on_chapter_pressed() -> void:
	TransitionScreen.transition_to_scene("") #TODO: ADD GAME SCENE HERE

func _on_restart_pressed() -> void:
	TransitionScreen.transition_to_scene("") #TODO: ADD GAME SCENE HERE
