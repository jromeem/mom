extends Node
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed:
			SignalManager.spacebar_pressed_for_conjuration.emit()
		if event.keycode == KEY_ENTER and event.pressed:
			SignalManager.enter_pressed_for_casting.emit()
