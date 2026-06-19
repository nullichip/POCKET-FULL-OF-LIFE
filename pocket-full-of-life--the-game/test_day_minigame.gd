extends Node2D
@onready var sunlight = $WindowLight

@onready var hand_parts = [$Hands, $Thumbs]

@onready var paper = $Paper
var can_paper_shake = false
var paper_resting_x = 0.0
var paper_resting_y = 0.0
@onready var question_text = $Paper/QuestionText
@onready var answer_input = $Paper/AnswerInput
var normal_questions = {
	"What is 7 * 6?" : "42",
	"What is the square root of 144?" : "12",
	"If Johnny has four hundred and seventeen apples and Anna has seven hundred and twenty apples, how many more apples does Anna have?" : "303",
	"What is 133 * 2?" : "266",
	"A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost?" : "0.5 cents",
	"A patch of lilypads doubles in size every day. If it takes 48 days for the patch to cover the entire lake, how long does it take to cover half the lake?" : "47 days",
	"What is 6 divided by 3(1 + 2)?" : "9",
	"Solve for x in the following equation:\n		3x+7= 22" : "5",
	"Solve for y in the following system of equations:\n			2x+y=10\n		x-y= 2" : "2",
	"Calculate the area of a circle that has a circumference of 18pi cm. Give your answer in terms of pi." : "81pi cm^2",
	"A right-angled triangle has a base of 5 cm and a hypotenuse of 13 cm. What is the length of the missing side?" : "12",
	"Spell the 11-letter word that means 'to provide lodging or sufficient space for.'" : "accommodate",
	"Spell the 10-letter word that means 'having mixed feelings or contradictory ideas about something or someone.'" : "ambivalent",
	"Spell the 10-letter word that means 'well meaning and kindly; serving a charitable rather than a profit-making purpose.'" : "benevolent",
	"Spell the 9-letter word that means 'a harsh, discordant mixture of sounds.'" : "cacophony",
	"Spell the 9-letter word that means 'sluggish, apathetic, or lacking energy'" : "lethargic",
	#"" : "",

}
var current_correct_answer = ""
var questions_answered = 0
var score = 0
var max_questions = 4

var available_questions = {}

var test_finished = false

@onready var entity_bodies = $EntityBodies
@onready var entity_heads = $EntityHeads

var blank_count = 0
var max_blanks = 3

var base_scale = Vector2(1.0, 1.0)
var base_positions = {}

var time_passed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for part in hand_parts:
		base_positions[part] = part.position
	
	base_positions[entity_bodies] = entity_bodies.position
	base_positions[entity_heads] = entity_heads.position
		
	available_questions = normal_questions.duplicate()
	
	$Paper/AnswerInput.clear()
	var picked_question = available_questions.keys().pick_random()
	$Paper/QuestionText.text = picked_question
	current_correct_answer = available_questions[picked_question]
	available_questions.erase(picked_question)
	
	$AnimationPlayer.play("paper_drop")
	
	await $AnimationPlayer.animation_finished
	paper_resting_x = $Paper.position.x
	paper_resting_y = $Paper.position.y
	can_paper_shake = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	
	#hands
	for part in hand_parts:
		#first value is the speed, second value is the distance it moves side to side & up and down
		part.position.x = base_positions[part].x + cos(time_passed * 110.0) * 0.8
		part.position.y = base_positions[part].y + sin(time_passed * 2.0) * 4.0
	
	if can_paper_shake:
		$Paper.position.y = paper_resting_y + sin(time_passed * 2.0) * 4.0
	
	#entities
	if randi() % 4 == 0:
		entity_bodies.position.x = base_positions[entity_bodies].x + randf_range(-1.0, 1.0)
		entity_bodies.position.y = base_positions[entity_bodies].y + randf_range(-1.0, 1.0)
	else:
		entity_bodies.position.x = base_positions[entity_bodies].x
		entity_bodies.position.y = base_positions[entity_bodies].y
	if randi() % 3 == 0:
		entity_heads.position.x = base_positions[entity_heads].x + randf_range(-2.0, 5.0)
		entity_heads.position.y = base_positions[entity_heads].y + randf_range(-2.0, 2.0)
	else:
		entity_heads.position.x = base_positions[entity_heads].x 
		entity_heads.position.y = base_positions[entity_heads].y


func _on_paper_pressed() -> void:
	if test_finished == true:
		return
	can_paper_shake = false
	var tween = create_tween()
	$Paper.z_index = 10
	$Paper/ExitButton.z_index = 11
	tween.tween_property($Paper, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($Paper, "position:y", paper_resting_y - 100, 0.5).set_trans(Tween.TRANS_SINE)
	
	$Paper/AnswerInput.mouse_filter = Control.MOUSE_FILTER_STOP
	$Paper/AnswerInput.visible = true
	$Paper/QuestionText.visible = true

func _on_answer_input_text_submitted(new_text: String) -> void:
	var player_guess = new_text.strip_edges().to_lower()
	
	#For leaving an answer blank
	if player_guess == "":
		blank_count += 1
		if blank_count > max_blanks:
			DialogueManager.show_dialogue("I can't leave it blank...")
			return
		else:
			questions_answered += 1
			if questions_answered >= max_questions:
				finish_test()
			else:
				load_next_question()
			return
	
	#For answering questions normally
	questions_answered += 1
	if player_guess == current_correct_answer:
		score += 1
	else:
		wrong_answer_shake()
	
	if questions_answered >= max_questions:
		finish_test()
	else:
		load_next_question()	

func load_next_question() -> void:
	var original_pos_y = $Paper.position.y
	var flip_out_tween = create_tween()
	flip_out_tween.tween_property($Paper, "position:y", -1000.0, 0.5).set_trans(Tween.TRANS_SINE)
	await flip_out_tween.finished
	
	$Paper/AnswerInput.clear()
	var picked_question = available_questions.keys().pick_random()
	$Paper/QuestionText.text = picked_question
	current_correct_answer = normal_questions[picked_question]
	available_questions.erase(picked_question)
	
	var flip_in_tween = create_tween()
	flip_in_tween.tween_property($Paper, "position:y", original_pos_y, 1).set_trans(Tween.TRANS_BOUNCE)

func wrong_answer_shake() -> void:
	var nope_tween = create_tween()
	var original_x = $Paper.position.x
	
	nope_tween.tween_property($Paper, "position:x", original_x - 15.0, 0.05)
	nope_tween.tween_property($Paper, "position:x", original_x + 15.0, 0.05)
	nope_tween.tween_property($Paper, "position:x", original_x - 15.0, 0.05)
	nope_tween.tween_property($Paper, "position:x", original_x + 15.0, 0.05)
	nope_tween.tween_property($Paper, "position:x", original_x, 0.05)

func finish_test() -> void:
	test_finished = true
	
	$Paper/AnswerInput.visible = false
	$Paper/AnswerInput.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Paper/AnswerInput.clear()
	
	$Paper/QuestionText.add_theme_font_size_override("font_size", 40)
	$Paper/QuestionText.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	$Paper/QuestionText.text = 'You reached the end of the test module.\nSCORE:' + str(score) + "/" + str(max_questions)
	
	await get_tree().create_timer(3.0).timeout
	
	$Paper/ExitButton.visible = true
	$Paper/ExitButton/AnimationPlayer.play("exit_fade_in")

func _on_exit_button_pressed() -> void:
	print("Pretending to go to the classroom")
	TransitionScreen.transition_to_scene("")


func _on_exit_button_mouse_entered() -> void:
	var hover = create_tween()
	hover.tween_property($Paper/ExitButton, "scale", Vector2(1.1, 1.1), 0.1)

func _on_exit_button_mouse_exited() -> void:
	var hover_out = create_tween()
	hover_out.tween_property($Paper/ExitButton, "scale", Vector2(1.0, 1.0), 0.1)
