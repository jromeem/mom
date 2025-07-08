extends Control
class_name Cursor

var grid_size = 16
@onready var outline: ColorRect = $Outline
@onready var center: ColorRect = $Center

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var world_position = get_global_mouse_position()
			handle_click(world_position)

func handle_click(pos):
	var _clicked_pos = snap_to_grid(pos)
	SignalManager.terrain_clicked_for_movement.emit(pos)

func _process(_delta: float) -> void:
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
