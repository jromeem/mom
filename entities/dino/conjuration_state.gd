extends State
class_name ConjurationState

@export var character: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var fx: ConjuringFxComponent

func can_move() -> bool:
	return false  # Can't move while conjuring

func enter():
	print("entering Conjuration state")
	sprite.play("conjuring")
	fx.add()
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_ended)
	SignalManager.enter_pressed_for_casting.connect(_on_conjuration_submitted)
	
func exit():
	print("exiting Conjuration state")
	fx.remove()
	SignalManager.spacebar_pressed_for_conjuration.disconnect(_on_conjuration_ended)
	
func _on_conjuration_submitted():
	transitioned.emit(self, "IdleState")

func _on_conjuration_ended():
	transitioned.emit(self, "IdleState")
