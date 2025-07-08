extends Node2D
class_name ConjuringFxComponent

@onready var conjuring_fx: AnimatedSprite2D = $ConjuringFx

func add():
	conjuring_fx.play("smoke_circle")
	conjuring_fx.visible = true

func remove():
	conjuring_fx.stop()
	conjuring_fx.visible = false
