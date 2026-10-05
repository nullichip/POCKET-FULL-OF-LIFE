extends Area2D

@export var dialogue_text: String = "Default text."
var is_player_near: bool = false

@onready var item = $Sprite2D

var normal_color = Color(1.0, 1.0, 1.0, 1.0)
var highlight_color = Color(2.394, 2.24, 0.0, 1.0)

func _process(delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("interact"):
		start_interaction()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = false

func start_interaction() -> void:
	var tico = get_tree().get_nodes_in_group("Player")[0]
	
	if tico.is_interacting:
		return 
		
	tico.is_interacting = true
	
	if tico.last_direction > 0:
		tico.animated_sprite.play("look_away_twd_right")
	else:
		tico.animated_sprite.play("look_away_twd_left")
		
	await DialogueManager.show_dialogue(dialogue_text)
	
	tico.is_interacting = false
	
	if tico.last_direction < 0:
		tico.animated_sprite.play("idle_twd_left")
	else:
		tico.animated_sprite.play("idle_twd_right")


func _on_mouse_entered() -> void:
	item.modulate = highlight_color

func _on_mouse_exited() -> void:
	item.modulate = normal_color
