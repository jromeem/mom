extends Node2D

@onready var rotate_me: Sprite2D = $SquishMe/RotateMe

func _ready() -> void:
	rotate_me.scale = Vector2(2, 2)

func _process(delta: float) -> void:
	rotate_me.rotate(delta * 2)
	rotate_me.scale *= Vector2(-0.05 * delta + 1, -0.05 * delta + 1)
