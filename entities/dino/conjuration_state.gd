extends State
class_name ConjurationState

@export var character: CharacterBody2D
@export var sprite: AnimatedSprite2D

func can_move() -> bool:
	return false  # Can't move while conjuring

func enter():
	print("entering Conjuration state")
	sprite.play("conjuring")
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_ended)
	
func exit():
	print("exiting Conjuration state")
	SignalManager.spacebar_pressed_for_conjuration.disconnect(_on_conjuration_ended)
	
func _on_conjuration_ended():
	transitioned.emit(self, "IdleState")
