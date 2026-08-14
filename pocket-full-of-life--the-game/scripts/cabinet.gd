extends Area2D

@onready var cabinet = $AnimatedSprite2D

var is_open: bool = false
var is_player_near: bool = false

func _ready() -> void:
	cabinet.play("closed_cabinet")

func _process(_delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("interact"):
		if is_open == false:
			open_interaction()
		else:
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
		
	cabinet.play("open_cabinet")
	is_open = true

	tico.is_interacting = true
	if tico.last_direction > 0:
		tico.animated_sprite.play("look_away_twd_right")
	else:
		tico.animated_sprite.play("look_away_twd_left")

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
