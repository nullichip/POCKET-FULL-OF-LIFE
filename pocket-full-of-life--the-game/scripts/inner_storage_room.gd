extends Control

func _on_b_1_pressed() -> void:
	shake_item($StorageRoom/B1)

func _on_b_2_pressed() -> void:
	shake_item($StorageRoom/B2)

func _on_cones_pressed() -> void:
	shake_item($StorageRoom/cones)

func _on_tennis_1_pressed() -> void:
	shake_item($StorageRoom/tennis1)

func _on_tennis_2_pressed() -> void:
	shake_item($StorageRoom/tennis2)

func _on_cart_pressed() -> void:
	shake_item($StorageRoom/cart)

func _on_b_3_pressed() -> void:
	shake_item($StorageRoom/B3)

func _on_b_4_pressed() -> void:
	shake_item($StorageRoom/B4)

func shake_item(target_item: Control) -> void:
	var shake_tween = create_tween()
	var start_pos = target_item.position
	
	var shake_amt = 0.5
	var speed = 0.05
	
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(0, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos, speed)
