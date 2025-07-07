extends CharacterBody2D

@export var is_point_click_navigation: bool = true
@onready var follows_component: FollowsComponent = $"FollowsComponent"
@onready var conjuring_fx_component: ConjuringFxComponent = $ConjuringFxComponent
@onready var state_machine: StateMachine = $"StateMachine"

func _ready() -> void:
	if is_point_click_navigation:
		SignalManager.terrain_clicked_for_movement.connect(_on_terrain_clicked_for_movement)
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_toggle)
	SignalManager.enter_pressed_for_casting.connect(_on_conjure_submitted)

# Helper functions to check state
func can_conjure() -> bool:
	return state_machine.current_state.name != "NavigateState" or state_machine.current_state.name != "MovingState"

func is_conjuring() -> bool:
	return state_machine.current_state.name == "ConjurationState"

func can_move() -> bool:
	return not is_conjuring()  # Can't move while conjuring

func is_navigating() -> bool:
	return state_machine.current_state.name == "NavigateState"

func is_idle() -> bool:
	return state_machine.current_state.name == "IdleState"

func _on_conjuration_toggle():
	if is_navigating():
		return  # Can't conjure while moving

	if is_conjuring():
		state_machine._on_child_transitioned(state_machine.current_state, "IdleState")
	else:
		state_machine._on_child_transitioned(state_machine.current_state, "ConjurationState")

func _on_conjure_submitted():
	# placeholder -- should go to CastingState
	if is_conjuring():
		state_machine._on_child_transitioned(state_machine.current_state, "IdleState")

func _on_terrain_clicked_for_movement(pos: Vector2):
	if is_conjuring():
		return  # Can't move while conjuring
	
	follows_component.set_target(pos)
	state_machine._on_child_transitioned(state_machine.current_state, "NavigateState")

func _input(event):
	# WASD movement
	var direction = Input.get_vector("left", "right", "up", "down")

	if direction:
		if can_move():
			state_machine._on_child_transitioned(state_machine.current_state, "MovingState")
	
	# Point-and-click (if enabled)
	if is_point_click_navigation and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if can_move():
				var world_position = get_global_mouse_position()
				follows_component.set_target(world_position)
				state_machine._on_child_transitioned(state_machine.current_state, "NavigateState")
