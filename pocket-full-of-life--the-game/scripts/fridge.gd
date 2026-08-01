extends Node2D

@onready var fridge = $AnimatedSprite2D

var is_open: bool = false

func _ready() -> void:
	fridge.play("closed")

func _on_texture_button_pressed() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() == 0:
			return 
	var tico = player[0]
	
	if is_open == false:
		if tico.is_interacting:
			return
		fridge.play("open_fridge")
		is_open = true
	
		tico.is_interacting = true
		if tico.last_direction > 0:
			tico.animated_sprite.play("look_away_twd_right")
		else:
			tico.animated_sprite.play("look_away_twd_left")
	else:
		fridge.play("close_fridge")
		is_open = false
		
		await fridge.animation_finished
		
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
