extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $DinoSprite
@onready var follows_component: FollowsComponent = $"FollowsComponent"
@onready var state_machine: StateMachine = $"StateMachine"

func _ready() -> void:
	var cursor = get_tree().get_first_node_in_group("Cursor")
	cursor.terrain_clicked_for_movement.connect(_on_terrain_clicked_for_movement)

func _on_terrain_clicked_for_movement(position: Vector2):
	follows_component.set_target(position)
	state_machine._on_child_transitioned(state_machine.current_state, "NavigateState")
