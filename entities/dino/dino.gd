extends CharacterBody2D

var concentration_meter: float = 100.0

@onready var meter_rect: ColorRect = $ConcentrationMeter/ColorRect
@export var is_point_click_navigation: bool = true
@onready var conjuring: ConjuringHead = $Camera2D/Conjuring
@onready var follows_component: FollowsComponent = $"FollowsComponent"
@onready var conjuring_fx_component: ConjuringFxComponent = $ConjuringFxComponent
@onready var state_machine: StateMachine = $"StateMachine"

func _ready() -> void:
	if is_point_click_navigation:
		SignalManager.terrain_clicked_for_movement.connect(_on_terrain_clicked_for_movement)
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_toggle)
	SignalManager.enter_pressed_for_casting.connect(_on_conjure_submitted)
	SignalManager.valid_spellword.connect(_on_spell_ready)

func _process(delta: float) -> void:
	meter_rect.size.x -= delta * 0.5

# Helper functions to check state
func can_conjure() -> bool:
	return state_machine.current_state.name != "NavigateState" or state_machine.current_state.name != "MovingState"

func is_conjuring() -> bool:
	return state_machine.current_state.name == "ConjurationState"
	
func is_casting() -> bool:
	return state_machine.current_state.name == "CastingState"

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
	var spellword = conjuring.get_spellword()
	print('we have a spell ready!!', spellword)
	if spellword.length() > 0:
		state_machine._on_child_transitioned(state_machine.current_state, "CastingState")

func _on_spell_ready(_spellword):
	pass

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
