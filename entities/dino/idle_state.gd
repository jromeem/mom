extends State
class_name IdleState

@onready var sprite: AnimatedSprite2D = $"../../Sprite"

func can_move() -> bool:
	return true
	
func can_conjure() -> bool:
	return true

func enter():
	sprite.play("idle")
