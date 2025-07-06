extends Node2D
class_name FollowsComponent

var grid_size = 16
var target_square: ColorRect = null
var outline_square: ColorRect = null

@export var speed: float
@export var target_visualized: bool
@export var follower: CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	SignalManager.reached_target.connect(_on_character_navigated.bind())

func set_target(pos: Vector2):
	if (pos):
		nav_agent.target_position = pos
		
		var cursor = get_tree().get_first_node_in_group("Cursor")
		place_target(cursor.snap_to_grid(pos))
		
func remove_target():
	set_target(follower.position)
	
func place_target(pos: Vector2):
	if (not target_visualized):
		return

	# Remove existing target square
	if target_square and is_instance_valid(target_square):
		target_square.queue_free()
		outline_square.queue_free()

	# Create a new ColorRect for the target
	target_square = ColorRect.new()
	target_square.size = Vector2(grid_size, grid_size)
	target_square.color = Color(1, 0, 0, 0.30)  # Transparent red
	target_square.global_position = pos
	target_square.z_index = 1
	
	# Create outline
	outline_square = ColorRect.new()
	outline_square.size = Vector2(grid_size + 4, grid_size + 4)
	outline_square.color = Color(1, 0, 0, 0.1)  # Transparent red
	outline_square.global_position = Vector2(pos.x - 2, pos.y - 2)
	outline_square.z_index = 1
	
	# Add to the root of the current scene
	get_tree().current_scene.add_child(target_square)
	get_tree().current_scene.add_child(outline_square)

func follow_target():
	if !nav_agent.target_position:
		return
		
	if nav_agent.is_navigation_finished():
		follower.velocity = Vector2.ZERO
		SignalManager.reached_target.emit(follower)
		return

	var follower_position = follower.global_position
	var next_path_position = nav_agent.get_next_path_position()
	var new_velocity = follower_position.direction_to(next_path_position) * speed
	follower.velocity = new_velocity

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	follower.velocity = safe_velocity
	
func _on_character_navigated(who_are_you: CharacterBody2D):
	# Remove target square upon reaching target
	if who_are_you == follower and target_square and is_instance_valid(target_square):
		target_square.queue_free()
		outline_square.queue_free()
