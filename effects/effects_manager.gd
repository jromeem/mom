extends Node2D
class_name EffectsManager

@onready var cursor: Cursor = $Cursor
@onready var dino: CharacterBody2D = $"../Dino"

const PYRI = preload("res://effects/pyri.tscn")

#spell_data = {
	#"valid": true,
	#"spell": spell_input,
	#"prefixes": detected_prefixes,
	#"root": detected_root,
	#"suffixes": detected_suffixes,
	#"categories": {
		#"prefix_categories": used_prefix_categories,
		#"suffix_categories": used_suffix_categories
	#}
#}

func _ready() -> void:
	cursor.visible = true
	SignalManager.spell_prepared.connect(_on_spell_prepared)
	SignalManager.concentration_depleted.connect(_on_concentration_depleted)

func handle_click(pos: Vector2):
	if dino.is_casting():
		var pyri_instance = PYRI.instantiate()
		pyri_instance.global_position = Vector2(pos.x + 8, pos.y - 5)
		get_tree().current_scene.add_child(pyri_instance)

func _input(event):
	if dino.is_casting():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var pos = cursor.snap_to_grid(get_global_mouse_position())
				handle_click(pos)
	
func _on_concentration_depleted():
	cursor.visible = false

func _on_spell_prepared(spell_data):
	if spell_data.spell == "pyri":
		print("summoned pyri!")
	else:
		print("summomed something else...")
