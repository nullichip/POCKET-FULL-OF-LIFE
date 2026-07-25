extends Control

@onready var score = $ScoreLabel

signal game_over

var cows_counted: int = 0
var hearts: int = 3

func _on_entity_pressed() -> void:
	hearts -= 1
	update_ui()
	
	if hearts <= 0:
		prints("Wake up, Tico...WAKE UP!")
		game_over.emit()
		queue_free()
	elif hearts > 0:
		prints("You survived the nightmare...")

func update_ui() -> void:
	score.text = "Cows: " + str(cows_counted)
