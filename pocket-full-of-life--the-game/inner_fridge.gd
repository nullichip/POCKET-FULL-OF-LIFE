extends Control

func _on_milk_pressed() -> void:
	shake_item($Fridge/Milk)

func _on_bananas_pressed() -> void:
	shake_item($Fridge/Bananas)

func _on_passion_fruit_pressed() -> void:
	shake_item($Fridge/PassionFruit)

func _on_pomegranate_pressed() -> void:
	shake_item($Fridge/Pomegranate)

func _on_kiwi_pressed() -> void:
	shake_item($Fridge/Kiwi)

func _on_blueberries_pressed() -> void:
	shake_item($Fridge/Blueberries)

func shake_item(target_item: Control) -> void:
	var shake_tween = create_tween()
	var start_pos = target_item.position
	
	var shake_amt = 1.0
	var speed = 0.05
	
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(-shake_amt, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(shake_amt, -shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos + Vector2(0, shake_amt), speed)
	shake_tween.tween_property(target_item, "position", start_pos, speed)
