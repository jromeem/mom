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
	SignalManager.reached_target.connect(_on_reached_target)
	
func exit():
	print("exiting Navigate state")
	SignalManager.reached_target.disconnect(_on_reached_target.bind())
	
func update(_delta: float):
	sprite.play("walk")
	if (character.velocity.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	follows_component.follow_target()
	character.move_and_slide()

func _on_reached_target(who_are_you: CharacterBody2D):
	if (who_are_you == character):
		transitioned.emit(self, "IdleState")
