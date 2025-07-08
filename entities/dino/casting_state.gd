extends State
class_name CastingState

@onready var concentration_meter: Control = $"../../ConcentrationMeter"
@onready var casting_fx_component: Node2D = $"../../CastingFxComponent"

func enter():
	print('entering CastingState')
	concentration_meter.visible = true
	casting_fx_component.visible = true
	pass

func exit():
	print('exiting CastingState')
	concentration_meter.visible = false
	casting_fx_component.visible = false
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
