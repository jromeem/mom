extends Node2D

@onready var rotate_me: Sprite2D = $SquishMe/RotateMe

func _process(delta: float) -> void:
	rotate_me.rotate(delta * 2)
