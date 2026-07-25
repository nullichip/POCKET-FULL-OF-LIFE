extends Control

@onready var score = $Box/ScoreLabel

@export var cow_scene: PackedScene
@export var entity_scene: PackedScene
@export var volleyball_scene: PackedScene

@export var full_heart: Texture2D
@export var broken_heart: Texture2D

@onready var heart1 = $HBoxContainer/Heart1
@onready var heart2 = $HBoxContainer/Heart2
@onready var heart3 = $HBoxContainer/Heart3

signal game_over
signal night_won

var vbs_counted: int = 0
var entities_counted: int = 0
var hearts: int = 3
var items_left_on_screen: int = 0

func _ready() -> void:
	start_night()

func start_night() -> void:
	randomize()
	
	var total_appearances = randi_range(6, 13)
	
	items_left_on_screen = total_appearances
	vbs_counted = 0
	hearts = 3
	update_ui()
	
	for i in range(total_appearances):
		spawn_item()
		await get_tree().create_timer(1.5).timeout

func spawn_item() -> void:
	var random_type = randi() % 3
	var item_instance
	
	if random_type == 0:
		item_instance = cow_scene.instantiate()
		item_instance.pressed.connect(_on_cow_pressed.bind(item_instance))
	elif random_type == 1:
		item_instance = entity_scene.instantiate()
		item_instance.pressed.connect(_on_entity_pressed.bind(item_instance))
	else:
		item_instance = volleyball_scene.instantiate()
		item_instance.pressed.connect(_on_volleyball_pressed.bind(item_instance))

	item_instance.get_node("AnimationPlayer").play("jump_animation")
	$SpawnLayer.add_child(item_instance)

func _on_cow_pressed(clicked_item: Node) -> void:
	clicked_item.queue_free()
	check_remaining_items()

func _on_entity_pressed(clicked_item: Node) -> void:
	hearts -= 1
	clicked_item.queue_free()
	
	if hearts == 2:
		heart3.texture = broken_heart
	elif hearts == 1:
		heart2.texture = broken_heart
	else:
		heart1.texture = broken_heart
		print("Wake up, Tico...GET UP NOW!")
		game_over.emit()
	
	update_ui()
	check_remaining_items()

func _on_volleyball_pressed(clicked_item: Node) -> void:
	vbs_counted += 1
	update_ui()
	clicked_item.queue_free()
	check_remaining_items()

func check_remaining_items() -> void:
	items_left_on_screen -= 1
	
	if items_left_on_screen <= 0 and hearts > 0:
		print("You defeated the nightmare...Time to get up!")
		night_won.emit()

func update_ui() -> void:
	score.text = "Volleyballs: " + str(vbs_counted)
