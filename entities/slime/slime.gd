extends CharacterBody2D

var update_timer: float = 0.0

@export var update_interval = 0.3
@export var max_follow_distance = 80.0

@onready var dino: CharacterBody2D = $"../Dino"
@export var slime_sprite: AnimatedSprite2D
@export var follows_component: FollowsComponent

func pet_update():
	var distance_to_dino = global_position.distance_to(dino.global_position)
	
	if distance_to_dino > max_follow_distance:
		follows_component.set_target(dino.global_position)
		
		slime_sprite.play("walk")
		
		if (velocity.x < 0):
			slime_sprite.flip_h = true
		else:
			slime_sprite.flip_h = false
	else:
		slime_sprite.play("idle")	

func _physics_process(delta):
	update_timer += delta
	
	if update_timer >= update_interval:
		pet_update()
		update_timer = 0.0
		
	follows_component.follow_target()
	move_and_slide()
