extends CharacterBody2D

@export var speed = 50
@export var follow_distance = 20.0
@export var max_follow_distance = 80.0
@export var update_interval = 0.3

@export var slime_sprite: AnimatedSprite2D
@export var follows_component: FollowsComponent

var update_timer: float = 0.0
@onready var dino: CharacterBody2D = $"../Dino"

func _physics_process(delta):
	var distance_to_dino = global_position.distance_to(dino.global_position)
	
	if distance_to_dino > max_follow_distance:
		follows_component.set_target(dino.global_position)
		follows_component.follow_target()
		slime_sprite.play("walk")
		
		if (velocity.x < 0):
			slime_sprite.flip_h = true
		else:
			slime_sprite.flip_h = false
			
		move_and_slide()
	else:
		slime_sprite.play("idle")
