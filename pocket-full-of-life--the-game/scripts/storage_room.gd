extends Node2D

@onready var storage = $AnimatedSprite2D
const INNER_STORAGE_VIEW = preload("res://scenes/interactive/inner_storage_room.tscn")

var is_open: bool = false
var spawned_UI_instance: Node = null

func _ready() -> void:
	storage.play("closed_storage")

func _on_texture_button_pressed() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() == 0:
			return 
	var tico = player[0]
	
	if is_open == false:
		if tico.is_interacting:
			return
		storage.play("open_storage")
		is_open = true
		
		tico.is_interacting = true
		if tico.last_direction > 0:
			tico.animated_sprite.play("look_away_twd_right")
		else:
			tico.animated_sprite.play("look_away_twd_left")
		
		await storage.animation_finished
		
		spawned_UI_instance = INNER_STORAGE_VIEW.instantiate()
		var ui_layer = get_tree().current_scene.get_node("UI_Layer_Gym")
		ui_layer.add_child(spawned_UI_instance)
	else:
		if spawned_UI_instance != null:
			spawned_UI_instance.queue_free()
			spawned_UI_instance = null
		
		storage.play("close_storage")
		is_open = false
		
		await storage.animation_finished
		
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
