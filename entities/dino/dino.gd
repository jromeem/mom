extends CharacterBody2D

# dino starting stats :)
# more to resource later (?)
var concentration: float = 30.0

@onready var state_machine: StateMachine = $"StateMachine"

func _ready() -> void:
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_toggle)

func can_conjure() -> bool:
	return state_machine.current_state.name != "NavigateState" or state_machine.current_state.name != "MovingState"

func can_move() -> bool:
	return not is_conjuring()

func is_conjuring() -> bool:
	return state_machine.current_state.name == "ConjurationState"
	
func is_casting() -> bool:
	return state_machine.current_state.name == "CastingState"

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

func _input(_event):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		if can_move():
			state_machine._on_child_transitioned(state_machine.current_state, "MovingState")
