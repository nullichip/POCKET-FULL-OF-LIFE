extends Area2D 

@onready var fridge = $AnimatedSprite2D

var normal_color = Color(1.0, 1.0, 1.0, 1.0)
var highlight_color = Color(2.394, 2.24, 0.0, 1.0)

const INNER_FRIDGE_VIEW = preload("res://scenes/interactive/inner_fridge.tscn")

var is_open: bool = false
var spawned_UI_instance: Node = null

var is_player_near: bool = false 

func _ready() -> void:
	fridge.play("closed")

func _unhandled_input(event: InputEvent) -> void:
	if is_player_near and event.is_action_pressed("interact"):
		if is_open == false:
			open_interaction()
		else:
			close_interaction()
			
	if is_open and event.is_action_pressed("ui_cancel"):
		close_interaction()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = false

func open_interaction() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() == 0:
			return 
	var tico = player[0]
	
	if tico.is_interacting:
		return
		
	fridge.play("open_fridge")
	is_open = true
	
	tico.is_interacting = true
	if tico.last_direction > 0:
		tico.animated_sprite.play("look_away_twd_right")
	else:
		tico.animated_sprite.play("look_away_twd_left")
	
	await fridge.animation_finished
	
	spawned_UI_instance = INNER_FRIDGE_VIEW.instantiate()
	var ui_layer = get_tree().current_scene.get_node("UI_Layer_Kitchen")
	ui_layer.add_child(spawned_UI_instance)
	
func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		close_interaction()

func close_interaction() -> void:
	if spawned_UI_instance != null:
		spawned_UI_instance.queue_free()
		spawned_UI_instance = null
	
	fridge.play("close_fridge")
	is_open = false
	
	await fridge.animation_finished
	
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() > 0:
		var tico = player[0]
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")

func _on_mouse_entered() -> void:
	fridge.modulate = highlight_color

func _on_mouse_exited() -> void:
	fridge.modulate = normal_color
