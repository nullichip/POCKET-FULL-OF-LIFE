extends Node2D

@onready var board = $Board
#const BOARD_VIEW = preload("res://scenes/interactive/close_up_board.tscn")

var is_open: bool = false
#var spawned_UI_instance: Node = null

func _on_texture_button_pressed() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	if player.size() == 0:
			return 
	var tico = player[0]
	
	if is_open == false:
		if tico.is_interacting:
			return
		is_open = true
		
		tico.is_interacting = true
		if tico.last_direction > 0:
			tico.animated_sprite.play("look_away_twd_right")
		else:
			tico.animated_sprite.play("look_away_twd_left")
		
		await board.animation_finished
		
		#spawned_UI_instance = BOARD_VIEW.instantiate()
		#var ui_layer = get_tree().current_scene.get_node("UI_Layer_Board")
		#ui_layer.add_child(spawned_UI_instance)
	else:
		#if spawned_UI_instance != null:
			#spawned_UI_instance.queue_free()
			#spawned_UI_instance = null
		
		is_open = false
		
		tico.is_interacting = false
		
		if tico.last_direction < 0:
			tico.animated_sprite.play("idle_twd_left")
		else:
			tico.animated_sprite.play("idle_twd_right")
