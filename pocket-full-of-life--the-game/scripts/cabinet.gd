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
		
		await cabinet.animation_finished
		
		#spawned_UI_instance = INNER_CABINET_VIEW.instantiate()
		#var ui_layer = get_tree().current_scene.get_node("UI_Layer_Kitchen")
		#ui_layer.add_child(spawned_UI_instance)
	else:
		#if spawned_UI_instance != null:
			#spawned_UI_instance.queue_free()
			#spawned_UI_instance = null
		
		cabinet.play("close_cabinet")
		is_open = false
		
		await cabinet.animation_finished
		
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
