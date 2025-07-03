extends CharacterBody2D

@export var speed = 70
@export var stuck_threshold = 2.0  # Distance threshold to consider stuck
@export var stuck_timeout = 5.0   # Time before giving up when stuck

@onready var dino_sprite: AnimatedSprite2D = $DinoSprite
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

signal dino_nav_finished
signal dino_stuck

# Stuck detection variables
var last_position: Vector2 = Vector2.ZERO
var stuck_timer: float = 0.0
var is_stuck: bool = false
var stuck_check_interval: float = 0.5  # Check every 0.5 seconds
var stuck_check_timer: float = 0.0

# Unstuck behavior variables
var unstuck_attempts: int = 0
var max_unstuck_attempts: int = 8
var unstuck_directions = [
	Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT,
	Vector2.UP + Vector2.LEFT, Vector2.UP + Vector2.RIGHT,
	Vector2.DOWN + Vector2.LEFT, Vector2.DOWN + Vector2.RIGHT
]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var world_position = get_global_mouse_position()
			handle_click(world_position)

func handle_click(pos):
	navigation_agent_2d.target_position = pos
	# Reset stuck detection when new target is set
	reset_stuck_detection()

func _ready():
	# Configure navigation agent
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.path_max_distance = 10.0
	
	# Wait for navigation to be ready
	call_deferred("actor_setup")
	
	last_position = global_position

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync
	await get_tree().physics_frame

func _physics_process(delta):
	# Check if we have a valid path and haven't reached the target
	if navigation_agent_2d.is_navigation_finished():
		dino_nav_finished.emit()
		velocity = Vector2.ZERO
		dino_sprite.play("idle")
		move_and_slide()
		reset_stuck_detection()
		return
	
	# Update stuck detection
	update_stuck_detection(delta)
	
	# Handle stuck behavior
	if is_stuck:
		handle_stuck_behavior(delta)
		return
	
	# Normal movement
	perform_normal_movement()

func update_stuck_detection(delta):	
	stuck_check_timer += delta
	
	if stuck_check_timer >= stuck_check_interval:
		var distance_moved = global_position.distance_to(last_position)
		
		if distance_moved < stuck_threshold:
			stuck_timer += stuck_check_interval
			
			if stuck_timer >= stuck_timeout and not is_stuck:
				is_stuck = true
				unstuck_attempts = 0
				dino_stuck.emit()
				print("Dino is stuck! Attempting to unstuck...")
		else:
			# Reset stuck timer if moving normally
			stuck_timer = 0.0
		
		last_position = global_position
		stuck_check_timer = 0.0

func handle_stuck_behavior(delta):
	dino_sprite.play("walk")  # Keep walking animation during unstuck attempts
	
	# Try different directions to unstuck
	if unstuck_attempts < max_unstuck_attempts:
		var unstuck_direction = unstuck_directions[unstuck_attempts % unstuck_directions.size()]
		var unstuck_velocity = unstuck_direction.normalized() * speed * 0.7  # Slightly slower
		
		velocity = unstuck_velocity
		move_and_slide()
		
		# Update sprite direction
		if velocity.x != 0:
			dino_sprite.flip_h = velocity.x < 0
		
		# Try next direction after a short time
		await get_tree().create_timer(0.3).timeout
		unstuck_attempts += 1
		
		# Check if we're no longer stuck
		var distance_moved = global_position.distance_to(last_position)
		if distance_moved > stuck_threshold:
			is_stuck = false
			stuck_timer = 0.0
			print("Dino unstuck! Resuming normal pathfinding.")
			return
	else:
		# Give up after max attempts
		print("Dino couldn't unstuck itself. Stopping pathfinding.")
		navigation_agent_2d.target_position = global_position  # Stop pathfinding
		velocity = Vector2.ZERO
		dino_sprite.play("idle")
		move_and_slide()
		reset_stuck_detection()

func perform_normal_movement():
	dino_sprite.play("walk")
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	
	# Handle sprite direction
	if global_position.x - next_path_position.x > 0:
		dino_sprite.flip_h = true
	else:
		dino_sprite.flip_h = false
	
	# Calculate new velocity
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

func reset_stuck_detection():
	is_stuck = false
	stuck_timer = 0.0
	stuck_check_timer = 0.0
	unstuck_attempts = 0
	last_position = global_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_dino_stuck() -> void:
	print("help i'm stuck!!!")
