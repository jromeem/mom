extends State
class_name NavigateState

@export var character: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var follows_component: FollowsComponent

func enter():
	sprite.play("walk")
	follows_component.reached_target.connect(_on_reached_target)

func exit():
	follows_component.reached_target.disconnect(_on_reached_target)
	
func update(_delta: float):
	sprite.play("walk")
	if (character.velocity.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	follows_component.follow_target()
	character.move_and_slide()

func _on_reached_target():
	# Transition back to idle when we reach our destination
	transitioned.emit(self, "IdleState")
