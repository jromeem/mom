extends State
class_name IdleState

@export var sprite: AnimatedSprite2D

func enter():
	sprite.play("idle")

func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
