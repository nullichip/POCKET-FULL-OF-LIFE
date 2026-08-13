extends CanvasLayer

@export var brush_size: int = 250
@export var erase_threshold: float = 0.50
@export var erase_speed: float = 0.50 

@onready var layer4 = $PracticeLayer
@onready var layer3 = $RedInkLayer

var erasable_images = []
var erasable_textures = []

var current_stage: int = 0
var erased_pixels: int = 0
var pixels_needed: int = 0

func _ready() -> void:
	setup_layer(layer4)
	setup_layer(layer3)
	
	var img_width = erasable_images[0].get_width()
	var img_height = erasable_images[0].get_height()
	pixels_needed = int((img_width * img_height) * erase_threshold)
	
	layer4.gui_input.connect(_on_top_layer_gui_input)

func setup_layer(layer_node: TextureRect) -> void:
	var img = layer_node.texture.get_image()
	img.convert(Image.FORMAT_RGBA8)
	var tex = ImageTexture.create_from_image(img)
	layer_node.texture = tex
	
	erasable_images.append(img)
	erasable_textures.append(tex)

func _on_top_layer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_pos = layer4.get_local_mouse_position()
		erase_at_position(local_pos)

func erase_at_position(pos: Vector2) -> void:
	
	# CHANGED THIS: Now we loop through ALL layers up to our current stage!
	# If we are on stage 1 (the red layer), it will erase stage 0 AND stage 1 at the same time.
	for i in range(current_stage + 1):
		
		# Safety check just in case we go out of bounds
		if i >= erasable_images.size():
			continue
			
		var img = erasable_images[i]
		var tex = erasable_textures[i]
		
		var start_x = max(0, int(pos.x) - brush_size)
		var end_x = min(img.get_width(), int(pos.x) + brush_size)
		var start_y = max(0, int(pos.y) - brush_size)
		var end_y = min(img.get_height(), int(pos.y) + brush_size)
		
		var modified = false
		
		for x in range(start_x, end_x):
			for y in range(start_y, end_y):
				var dist = Vector2(x, y).distance_to(pos)
				
				if dist <= brush_size:
					var current_color = img.get_pixel(x, y)
					
					if current_color.a > 0.0:
						var brush_intensity = 1.0 - (dist / float(brush_size))
						var alpha_reduction = brush_intensity * erase_speed
						current_color.a = max(0.0, current_color.a - alpha_reduction)
						
						img.set_pixel(x, y, current_color) 
						modified = true
						
						# CHANGED THIS: Only count the erased pixels for the DEEPEST layer we are currently on.
						# This prevents the threshold from triggering too early.
						if current_color.a == 0.0 and i == current_stage:
							erased_pixels += 1 
						
		if modified:
			tex.update(img)
			
	# Check threshold AFTER all layers are updated
	if erased_pixels >= pixels_needed:
		if current_stage < erasable_images.size() - 1:
			current_stage += 1
			erased_pixels = 0 
			print("Threshold reached! Now erasing down to layer: ", current_stage)
