extends Node2D
class_name ConjuringFxComponent

@onready var conjuring_fx: AnimatedSprite2D = $ConjuringFx

func _ready() -> void:
	conjuring_fx.visible = false

func add_fx():
	conjuring_fx.play("smoke_circle")
	conjuring_fx.visible = true

func remove_fx():
	conjuring_fx.stop()
	conjuring_fx.visible = false
