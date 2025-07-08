extends Node
class_name SpellManager

var spell_data: Dictionary = {}

# Define roots, prefixes, and suffixes for validation
var lesser_roots = ["pyri", "aqua", "volt", "zeph", "terr", "lux", "nox", "ferrum"]
var higher_roots = ["ignis", "glaci", "fulgur", "aether", "gaia", "lumen", "umbra", "prisma", "corpus", "mentis", "luxus", "chron", "sensus", "vita", "mortis", "ordo"]
var roots = lesser_roots + higher_roots

var prefixes = {
	"targeting": ["ma", "in", "ex"],
	"amplification": ["ka", "epi", "tri"],
	"control": ["ra", "su", "pa"],
	"utility": ["ve", "xo", "dis"]
}

var suffixes = {
	"power": ["lo", "ri", "sha"],
	"duration": ["len", "tan"],
	"effect_modifiers": ["nu", "dra", "via", "tos", "rum", "sol"]
}

# Instead of just returning true/false, return the parsed spell data
func parse_spell(spell_input: String) -> Dictionary:
	# Make a copy of the input to work with
	var remaining_text = spell_input
	
	# Track detected components for highlighting
	var detected_root = ""
	var detected_prefixes = []
	var detected_suffixes = []
	
	# Track used categories to ensure one prefix/suffix per category
	var used_prefix_categories = {}
	var used_suffix_categories = {}
	
	# Step 1: Detect prefixes
	var prefix_found = true
	while prefix_found and remaining_text.length() > 0:
		prefix_found = false
		for category in prefixes:
			if category in used_prefix_categories:
				continue  # Skip if category already used
				
			for prefix in prefixes[category]:
				if remaining_text.begins_with(prefix):
					detected_prefixes.append(prefix)
					SignalManager.prefix_detected.emit(prefix)
					used_prefix_categories[category] = true
					remaining_text = remaining_text.substr(prefix.length())
					prefix_found = true
					break
	
	# Step 2: Detect root (mandatory)
	var root_found = false
	for root in roots:
		if remaining_text.begins_with(root):
			detected_root = root
			remaining_text = remaining_text.substr(root.length())
			root_found = true
			SignalManager.root_detected.emit(root)
			break
	
	if not root_found:
		return {"valid": false, "error": "No valid root found"}
	
	# Step 3: Detect suffixes
	while remaining_text.length() > 0:
		var suffix_found = false
		
		# Try to match a suffix
		for category in suffixes:
			if category in used_suffix_categories:
				continue  # Skip if category already used
				
			for suffix in suffixes[category]:
				if remaining_text.begins_with(suffix):
					detected_suffixes.append(suffix)
					used_suffix_categories[category] = true
					remaining_text = remaining_text.substr(suffix.length())
					suffix_found = true
					SignalManager.suffix_detected.emit(suffix)
					break
			
			if suffix_found:
				break
		
		if not suffix_found:
			return {"valid": false, "error": "Not a valid spell"}
		
		# If we've processed all remaining text, break the loop
		if remaining_text.length() == 0:
			break
	
	# All text should be consumed by valid components
	if remaining_text.length() > 0:
		return {"valid": false, "error": "Parsing error"}
	
	spell_data = {
		"valid": true,
		"spell": spell_input,
		"prefixes": detected_prefixes,
		"root": detected_root,
		"suffixes": detected_suffixes,
		"categories": {
			"prefix_categories": used_prefix_categories,
			"suffix_categories": used_suffix_categories
		}
	}
	
	SignalManager.spell_fully_parsed.emit()
	return spell_data

func prepare_spell():
	print('preparing spell! ', spell_data["valid"])
	SignalManager.spell_prepared.emit(spell_data)
	
func flatten_array(nested_array: Array) -> Array:
	var flat_array = []
	for subarray in nested_array:
		for element in subarray:
			flat_array.append(element)
	return flat_array

# Custom function to check if a string begins with a substring at a specific index
func begins_with_at_index(string: String, substring: String, index: int) -> bool:
	if index < 0 or index >= string.length():
		return false  # Index out of bounds
	return string.substr(index, substring.length()) == substring

func clean_spell_input(input: String) -> String:
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z]")
	return regex.sub(input, "", true).strip_edges()
