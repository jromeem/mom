extends State
class_name IdleState

@export var sprite: AnimatedSprite2D

func can_move() -> bool:
	return true
	
func can_conjure() -> bool:
	return true

func enter():
	print("entering Idle state")
	sprite.play("idle")
