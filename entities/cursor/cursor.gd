extends Control
class_name Cursor

var grid_size = 16
@onready var outline: ColorRect = $Outline
@onready var center: ColorRect = $Center

# target square that is placed when player clicks on terrain
var target_square: ColorRect = null
var outline_square: ColorRect = null

signal terrain_clicked_for_movement(world_position: Vector2)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var world_position = get_global_mouse_position()
			handle_click(world_position)

func handle_click(pos):
	var clicked_pos = snap_to_grid(pos)
	create_target_square(clicked_pos)
	
	# emit signal that was clicked
	terrain_clicked_for_movement.emit(pos)

func create_target_square(pos: Vector2):
	# Remove existing target square
	if target_square and is_instance_valid(target_square):
		target_square.queue_free()
		outline_square.queue_free()
	
	# Create a new ColorRect for the target
	target_square = ColorRect.new()
	target_square.size = Vector2(grid_size, grid_size)
	target_square.color = Color(1, 0, 0, 0.30)  # Transparent red
	target_square.position = pos
	
	# Create outline
	outline_square = ColorRect.new()
	outline_square.size = Vector2(grid_size + 4, grid_size + 4)
	outline_square.color = Color(1, 0, 0, 0.1)  # Transparent red
	outline_square.position = Vector2(pos.x -2 , pos.y - 2)
	
	# Add it to the main scene (parent of cursor)
	get_parent().add_child(target_square)
	get_parent().add_child(outline_square)

func _process(delta: float) -> void:
	move_cursor()

func move_cursor():
	var mouse_pos = get_global_mouse_position()
	var snapped_pos = snap_to_grid(mouse_pos)
	
	# Move the Control to the snapped position
	global_position = snapped_pos

func snap_to_grid(pos: Vector2) -> Vector2:
	var snapped_x = round((pos.x - 8) / grid_size) * grid_size
	var snapped_y = round((pos.y - 8) / grid_size) * grid_size
	return Vector2(snapped_x, snapped_y)

func _on_dino_dino_nav_finished() -> void:
	# Remove the target square
	if target_square and is_instance_valid(target_square):
		target_square.queue_free()
		outline_square.queue_free()
		target_square = null
		#print("Target square removed")
