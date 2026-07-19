extends TextureButton

@export var slot_id: int = 1
@onready var time_stamp = $TimeStamp

var has_save_file: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_path = "user://save_slot_" + str(slot_id) + ".save"
	
	if FileAccess.file_exists(save_path):
		has_save_file = true
		
		var file = FileAccess.open(save_path, FileAccess.READ)
		var saved_text = file.get_as_text()
		
		var json = JSON.new()
		if json.parse(saved_text) == OK:
			var save_data = json.data
			if save_data.has("timestamp"):
				time_stamp.text = save_data["timestamp"]
			else:
				time_stamp.text = get_save_timestamp()
		else:
			has_save_file = false
			time_stamp.text = "---"

func _on_pressed() -> void:
	if has_save_file == true:
		var user_said_yes = await ConfirmationMenu.ask_question("Overwrite this saved file?")
		
		if user_said_yes == false:
			return
		
	print("Saving game slot: ", slot_id)
	
	time_stamp.text = get_save_timestamp()
	
	has_save_file = true
	
	GameManager.save_game(slot_id)

func get_save_timestamp() -> String:
	var time = Time.get_datetime_dict_from_system()
	var timestamp = "%02d/%02d/%d - %02d:%02d" % [
		time.month, time.day, time.year, time.hour, time.minute
	]
	
	return timestamp

#if needed to reset timestamps to empty (if needed for testing) go to Project -> Open User Data Folder and delete all saved files there.
