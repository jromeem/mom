extends Node2D

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D

func _ready() -> void:
	navigation_region_2d.navigation_polygon.agent_radius = 5
	navigation_region_2d.bake_navigation_polygon()
