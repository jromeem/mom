extends State
class_name CastingState

@onready var character = $"../.."
@onready var concentration_meter: Control = $"../../ConcentrationMeter"
@onready var casting_fx_component: Node2D = $"../../CastingFxComponent"
@onready var color_rect: ColorRect = $"../../ConcentrationMeter/ColorRect"
@onready var rotate_me: Sprite2D = $"../../CastingFxComponent/SquishMe/RotateMe"

var concentration_drain_rate: float = 3.0  # points per second
var initial_concentration: float

func enter():
	print('entering CastingState')
	concentration_meter.visible = true
	casting_fx_component.visible = true
	
	# Store initial concentration
	initial_concentration = character.concentration
	
	# Start concentration drain
	start_concentration_drain()

func start_concentration_drain():
	# Create a tween for smooth animation
	var tween = create_tween()
	tween.set_parallel(true)  # Allow multiple tweens to run simultaneously
	
	# Calculate drain duration (if you want it to drain completely)
	var drain_duration = character.concentration / concentration_drain_rate
	
	# Animate concentration meter scale/size
	tween.tween_property(color_rect, "size:x", 0, drain_duration)
	
	# Animate casting fx scale
	tween.tween_property(rotate_me, "scale", Vector2.ZERO, drain_duration)
	
	# Also drain the actual concentration value
	tween.tween_method(update_concentration, character.concentration, 0.0, drain_duration)
	
	# When finished, transition out of casting state
	tween.tween_callback(on_concentration_depleted).set_delay(drain_duration)

func update_concentration(value: float):
	character.concentration = value
	# You could also update a progress bar here if you have one
	# concentration_progress_bar.value = value

func on_concentration_depleted():
	print("Concentration depleted!")
	SignalManager.concentration_depleted.emit()
	transitioned.emit(self, "IdleState")

func update(_delta: float):
	# Handle early exit if concentration runs out naturally
	if character.concentration <= 0:
		transitioned.emit(self, "IdleState")

func exit():
	print('exiting CastingState')
	concentration_meter.visible = false
	casting_fx_component.visible = false
	# Reset scales in case we exit early
	color_rect.scale = Vector2.ONE
	rotate_me.scale = Vector2.ONE
