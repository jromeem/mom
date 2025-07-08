extends State
class_name MovingState

var speed: float = 80
var conjuring_started: bool
@onready var character: CharacterBody2D = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprite"

func enter():
	conjuring_started = false
	sprite.play("walk")
	
func update(_delta: float):
	# Early exit if conjuring - don't process ANY input
	if character.is_conjuring():
		character.velocity = Vector2.ZERO
		return
	
	# Only process movement if definitely not conjuring
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Apply movement
	character.velocity = direction * speed
	
	# Handle sprite flipping
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	character.move_and_slide()
	
	# Transition back to idle if no input
	if character.velocity == Vector2.ZERO:
		transitioned.emit(self, "IdleState")
