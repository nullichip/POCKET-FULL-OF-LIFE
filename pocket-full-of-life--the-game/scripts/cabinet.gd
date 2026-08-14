extends Node2D

@onready var cabinet = $AnimatedSprite2D
#const INNER_CABINET_VIEW = preload("res://scenes/interactive/inner_cabinet.tscn")

var is_open: bool = false
#var spawned_UI_instance: Node = null

func _ready() -> void:
	cabinet.play("closed_cabinet")

func _on_texture_button_pressed() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() == 0:
			return 
	var tico = player[0]
	
	if is_open == false:
		if tico.is_interacting:
			return
		cabinet.play("open_cabinet")
		is_open = true
		
		tico.is_interacting = true
		if tico.last_direction > 0:
			tico.animated_sprite.play("look_away_twd_right")
		else:
			tico.animated_sprite.play("look_away_twd_left")
	else:
		close_interaction()

func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		close_interaction()

func close_interaction() -> void:
	cabinet.play("close_cabinet")
	is_open = false
	
	await cabinet.animation_finished
	
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() > 0:
		var tico = player[0]
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
