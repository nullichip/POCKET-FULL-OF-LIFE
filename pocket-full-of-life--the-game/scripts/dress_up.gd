extends Control

@onready var tico_model = %tico
@onready var spotlight = %spotlight
@onready var pedestal = $ModelScreen/Pedestal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_outfit_with_flicker(new_outfit: CompressedTexture2D) -> void:
	var blackout = create_tween()
	blackout.tween_property(spotlight, "modulate:a", 0.3, 0.05)
	blackout.parallel().tween_property(tico_model, "modulate:a", 0.3, 0.05)
	blackout.tween_property(spotlight, "modulate:a", 0.8, 0.05)
	blackout.tween_property(spotlight, "modulate:a", 0.0, 0.05)
	blackout.parallel().tween_property(tico_model, "modulate:a", 0.0, 0.05)
	
	await blackout.finished
	
	tico_model.texture = new_outfit
	
	await get_tree().create_timer(0.1).timeout
	
	var lights_on = create_tween()
	lights_on.tween_property(spotlight, "modulate:a", 0.6, 0.05)
	lights_on.parallel().tween_property(tico_model, "modulate:a", 0.6, 0.05)
	lights_on.tween_property(spotlight, "modulate:a", 0.2, 0.05)
	lights_on.parallel().tween_property(tico_model, "modulate:a", 0.2, 0.05)
	lights_on.tween_property(spotlight, "modulate:a", 1.0, 0.05)
	lights_on.parallel().tween_property(tico_model, "modulate:a", 1.0, 0.05)

func _on_volleyball_icon_pressed() -> void:
	change_outfit_with_flicker(preload("res://Assets/Dress-Up/Sports Model.png"))
	print("Switched to VB Clothes")

func _on_nighttime_icon_pressed() -> void:
	change_outfit_with_flicker(preload("res://Assets/Dress-Up/Nighttime Model.png"))
	print("Switched to Nighttime Clothes")

func _on_school_icon_pressed() -> void:
	change_outfit_with_flicker(preload("res://Assets/Dress-Up/School Model.png"))
	print("Switched to School Clothes")

func _on_exit_button_pressed() -> void:
	var blackout = create_tween()
	blackout.tween_property(spotlight, "modulate:a", 0.3, 0.05)
	blackout.parallel().tween_property(tico_model, "modulate:a", 0.3, 0.05)
	blackout.tween_property(spotlight, "modulate:a", 0.8, 0.05)
	blackout.tween_property(spotlight, "modulate:a", 0.0, 0.05)
	blackout.parallel().tween_property(tico_model, "modulate:a", 0.0, 0.05)
	blackout.parallel().tween_property(pedestal, "modulate:a", 0.0, 0.05)
	
	
	await get_tree().create_timer(1).timeout

	
	queue_free()
