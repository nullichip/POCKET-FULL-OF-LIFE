extends Area2D

@onready var locker = $AnimatedSprite2D
#const INNER_GYM_LOCKER_VIEW = preload("res://scenes/interactive/inner_school_locker.tscn")

var is_open: bool = false
var is_player_near: bool = false
var spawned_UI_instance: Node = null

func _ready() -> void:
	locker.play("closed_locker")

func _process(_delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("interact"):
		if is_open == false:
			open_interaction()

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
		
	locker.play("open_locker")
	is_open = true
	
	tico.is_interacting = true
	if tico.last_direction > 0:
		tico.animated_sprite.play("look_away_twd_right")
	else:
		tico.animated_sprite.play("look_away_twd_left")
	
	await locker.animation_finished
	
	#spawned_UI_instance = INNER_LOCKER_VIEW.instantiate()
	#var ui_layer = get_tree().current_scene.get_node("UI_Layer_Lockerroom")
	#ui_layer.add_child(spawned_UI_instance)

func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		close_interaction()

func close_interaction() -> void:
	#if spawned_UI_instance != null:
		#spawned_UI_instance.queue_free()
		#spawned_UI_instance = null
	
	locker.play("close_locker")
	is_open = false
	
	await locker.animation_finished
	
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() > 0:
		var tico = player[0]
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
