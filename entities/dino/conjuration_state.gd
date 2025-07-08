extends State
class_name ConjurationState

var is_valid_word: bool = false
var spell_word: String = ''

@onready var character: CharacterBody2D = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprite"
@onready var fx: ConjuringFxComponent = $"../../ConjuringFxComponent"
@onready var text_box: LineEdit = $"../../Camera2D/TextBox"
@onready var spell_manager: Node = $"../../SpellManager"

func can_move() -> bool:
	return false

func enter():
	print("entering Conjuration state")
	fx.add()
	sprite.play("conjuring")
	text_box.editable = true	
	text_box.grab_focus()
	text_box.text_changed.connect(_on_text_box_text_changed)  # Add this line
	SignalManager.spacebar_pressed_for_conjuration.connect(_on_conjuration_ended)
	SignalManager.enter_pressed_for_casting.connect(_on_conjuration_submitted)
	
func exit():
	print("exiting Conjuration state")
	fx.remove()
	text_box.editable = false
	text_box.release_focus()
	text_box.text_changed.disconnect(_on_text_box_text_changed)  # Add this line
	SignalManager.spacebar_pressed_for_conjuration.disconnect(_on_conjuration_ended)
	SignalManager.enter_pressed_for_casting.disconnect(_on_conjuration_submitted)
	
func _on_conjuration_submitted():
	if is_valid_word:
		spell_manager.prepare_spell()
		transitioned.emit(self, "CastingState")
	else:
		transitioned.emit(self, "IdleState")

func _on_conjuration_ended():
	transitioned.emit(self, "IdleState")

func _on_text_box_text_changed(new_text: String) -> void:
	# Clean input
	spell_word = spell_manager.clean_spell_input(new_text)
	
	# Update text if it changed
	if spell_word != new_text:
		text_box.text = spell_word
		text_box.set_caret_column(spell_word.length())
	
	# Parse and validate
	var spell_data = spell_manager.parse_spell(spell_word.to_lower())
	is_valid_word = spell_data["valid"]
	
	if is_valid_word:
		SignalManager.valid_spellword.emit(spell_word, spell_data)
	else:
		SignalManager.invalid_spellword.emit(spell_word, spell_data["error"])
