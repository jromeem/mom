extends Node

# inputs: clicks and keys
signal spacebar_pressed_for_conjuration
signal terrain_clicked_for_movement(world_position: Vector2)

# component signals
signal reached_target(who_are_you: CharacterBody2D) # FollowsComponent
