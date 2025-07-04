extends Path2D

var move_speed: float = 50.0
@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var dummy_sprite: AnimatedSprite2D = $PathFollow2D/Dummy/AnimatedSprite2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	path_follow.progress += move_speed * delta
	
	# Flip sprite based on the x component of the direction
	if path_follow.progress_ratio > 0.5:
		dummy_sprite.flip_h = true   # Facing left
	else:
		dummy_sprite.flip_h = false  # Facing right
