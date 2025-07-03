extends Node2D

@onready var dino = $Dino
@onready var cursor: Control = $Cursor
@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D

func _ready() -> void:
	navigation_region_2d.navigation_polygon.agent_radius = 10
	navigation_region_2d.bake_navigation_polygon()

	# Connect the dino's navigation finished signal to the cursor
	if dino.has_signal("dino_nav_finished"):
		dino.dino_nav_finished.connect(cursor._on_dino_dino_nav_finished)
