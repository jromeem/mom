extends CharacterBody2D

@export var speed = 50
@export var follow_distance = 20.0
@export var max_follow_distance = 80.0
@export var update_interval = 0.3
@export var wander_range = 24.0  # How far to wander when idle

@onready var slime_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var dino: CharacterBody2D = null
var update_timer: float = 0.0
var wander_timer: float = 0.0
var wander_interval: float = 3.0  # Wander every 3 seconds when idle
var is_wandering: bool = false

func _ready():
	dino = get_node("../Dino")
	
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.path_max_distance = 10.0
	
	navigation_agent_2d.velocity_computed.connect(_on_velocity_computed)
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame

func _physics_process(delta):
	if not dino:
		return
	
	update_timer += delta
	wander_timer += delta
	
	if update_timer >= update_interval:
		update_pet_behavior()
		update_timer = 0.0
	
	# Handle movement
	if navigation_agent_2d.is_navigation_finished():
		velocity = Vector2.ZERO
		slime_sprite.play("idle")
		is_wandering = false
		move_and_slide()
		return
	
	perform_movement()

func update_pet_behavior():
	var distance_to_dino = global_position.distance_to(dino.global_position)
	
	if distance_to_dino > max_follow_distance:
		# Dino is far - follow immediately
		var follow_position = dino.global_position + Vector2(-20, randf_range(-10, 10))
		navigation_agent_2d.target_position = follow_position
		is_wandering = false
	elif distance_to_dino <= follow_distance:
		# Close to dino - maybe wander around
		if wander_timer >= wander_interval and not is_wandering:
			wander_near_dino()
	else:
		# Medium distance - stay put
		navigation_agent_2d.target_position = global_position

func wander_near_dino():
	# Wander in a small circle around the dino
	var random_offset = Vector2(
		randf_range(-wander_range, wander_range),
		randf_range(-wander_range, wander_range)
	)
	navigation_agent_2d.target_position = dino.global_position + random_offset
	is_wandering = true
	wander_timer = 0.0

func perform_movement():
	slime_sprite.play("walk")
	
	var current_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	
	var direction_x = current_position.x - next_path_position.x
	
	if direction_x > 0: 
		slime_sprite.flip_h = true  # Moving left
	else:
		slime_sprite.flip_h = false  # Moving left

	
	var new_velocity = current_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
