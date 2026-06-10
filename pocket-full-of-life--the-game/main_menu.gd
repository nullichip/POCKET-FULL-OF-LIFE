extends Control

@onready var menu_buttons = [$PlayButton, $ChapterButton, $RestartButton, $SettingButton]
@onready var game_title = $GameTitle
@onready var fire = $Fire

@onready var glitch_overlay = $GlitchOverlay
@onready var glitch_timer = $GlitchTimer

var base_scale = Vector2(1.0, 1.0)
var base_positions = {}

func _ready() -> void:
	for btn in menu_buttons:
		btn.mouse_entered.connect(animate_button.bind(btn, 1.1))
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
	glitch_overlay.color.a = randf_range(0.3, 0.80)
	glitch_timer.wait_time = randf_range(0.05, 0.4)
	
func _process(delta: float) -> void:
	for btn in menu_buttons:
		if randi() % 10 == 0:
			btn.position.x = base_positions[btn].x + randf_range(-8.0, 8.0)
			btn.position.y = base_positions[btn].y +randf_range(-4.0, 4.0)
			btn.scale.y = base_scale.y * randf_range(0.85, 1.1)
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
			
		if randi() % 10 == 0:
			fire.position.x = base_positions[fire].x + randf_range(-5.0, 5.0)
			fire.position.y = base_positions[fire].y + randf_range(-10.0, 10.0)
			fire.scale.y = base_scale.y + randf_range(0.35, 0.5)
		else:
			fire.position = base_positions[fire]
			fire.scale.y = base_scale.y
