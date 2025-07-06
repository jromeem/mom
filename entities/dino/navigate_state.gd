extends State
class_name NavigateState

var conjuration_queued: bool = false
@export var character: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var follows_component: FollowsComponent

func can_conjure() -> bool:
	return false  # Can't conjure while moving

func enter():
	print("entering Navigate state")
	sprite.play("walk")
	follows_component.reached_target.connect(_on_reached_target)
	
func exit():
	print("exiting Navigate state")
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
	# Transition back to idle unless conjuration was queued in the middle of navigation
	transitioned.emit(self, "IdleState")
