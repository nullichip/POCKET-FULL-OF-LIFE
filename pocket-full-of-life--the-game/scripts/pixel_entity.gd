extends CharacterBody2D

const CHASE_SPEED = 200.0
const WANDER_SPEED = 100.0

enum State { IDLE, CHASE, WANDER }
var current_state: State = State.IDLE
var move_direction: Vector2 = Vector2.ZERO
var last_direction_x: float = 1.0

@onready var entity = $AnimatedSprite2D
@onready var idle_timer = $IdleTimer

@export var is_story_locked: bool = false

var tico: Node2D = null

func _ready() -> void:
	$DetectionZone.body_entered.connect(_on_detection_zone_body_entered)
	$DetectionZone.body_exited.connect(_on_detection_zone_body_exited)
	idle_timer.timeout.connect(_on_idle_timer_timeout)

func _physics_process(delta: float) -> void:
	if is_story_locked:
		velocity = Vector2.ZERO
		play_idle_animation()
		return
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			play_idle_animation()
			move_and_slide()
		State.WANDER:
			velocity = move_direction * WANDER_SPEED
			play_walk_animation(move_direction.x)
			move_and_slide()
		State.CHASE:
			if tico != null:
				var distance_to_tico = global_position.distance_to(tico.global_position)
			
				if distance_to_tico > 30.0:
					move_direction = global_position.direction_to(tico.global_position)
					velocity = move_direction * CHASE_SPEED
					play_walk_animation(move_direction.x)
					move_and_slide()
				else:
					velocity = Vector2.ZERO
					print("Tico was caught")

func play_idle_animation() -> void:
	if last_direction_x < 0:
		entity.play("idle_left")
	else:
		entity.play("idle_right")

func play_walk_animation(direction_x: float) -> void:
	if direction_x < 0:
		entity.play("running_left")
	else:
		entity.play("running_right")



func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		tico = body
		current_state = State.CHASE
		idle_timer.stop()

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body == tico:
		tico = null
		current_state = State.IDLE
		idle_timer.start()

func _on_idle_timer_timeout() -> void:
	current_state = State.WANDER
	move_direction = Vector2(last_direction_x, 0).normalized()
