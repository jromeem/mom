extends Control
class_name ConjuringHead

@onready var spelling: Spelling = $Spelling

func get_spellword():
	return spelling.spellword
