extends Node2D
class_name FollowsComponent

@export var speed: float
@export var follower: CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

signal reached_target

func set_target(pos: Vector2):
	if (pos):
		nav_agent.target_position = pos
		
func remove_target():
	# reset target as self 
	set_target(follower.position)
	nav_agent.navigation_finished.emit()

func follow_target():
	if !nav_agent.target_position:
		return
		
	if nav_agent.is_navigation_finished():
		follower.velocity = Vector2.ZERO
		reached_target.emit()
		return

	var follower_position = follower.global_position
	var next_path_position = nav_agent.get_next_path_position()
	var new_velocity = follower_position.direction_to(next_path_position) * speed
	follower.velocity = new_velocity

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	follower.velocity = safe_velocity
