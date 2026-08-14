extends Area2D

@export var prompt_text: String = "Example..."
@export var destination_scene_path: String = ""
@export var target_spawn_node_name: String = ""
var is_player_near: bool = false

@onready var door_sprite = get_node_or_null("AnimatedSprite2D")

func _ready() -> void:
	if door_sprite != null:
		door_sprite.play("closed")

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
	
	tico.velocity = Vector2.ZERO
	
	if tico.last_direction > 0:
		tico.animated_sprite.play("look_away_twd_right")
	else:
		tico.animated_sprite.play("look_away_twd_left")
	
	if door_sprite != null:
			door_sprite.play("open")
			await door_sprite.animation_finished
	var player_said_yes = await ConfirmationMenu.ask_question(prompt_text)
	
	if player_said_yes:
		if destination_scene_path != "":
			if target_spawn_node_name != "":
				GameManager.target_spawn_name = target_spawn_node_name
			
			await TransitionScreen.transition_to_scene(destination_scene_path)
		else:
			print("Error: you forgot to set a destination point")
	else:
		if door_sprite != null:
			door_sprite.play("close")
			await door_sprite.animation_finished
		
		print("unlocking Tico")
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
		
	tico.is_interacting = false
