extends Node

# inputs signals
signal enter_pressed_for_casting
signal spacebar_pressed_for_conjuration
signal terrain_clicked_for_movement(world_position: Vector2)

# component signals
signal reached_target(who_are_you: CharacterBody2D) # FollowsComponent

# character signals
signal concentration_depleted

# spell manager signals
signal spell_fully_parsed
signal spell_prepared(spell_data)
signal invalid_spellword(spell_word, spell_data)
signal valid_spellword(spell_word, spell_data)
signal prefix_detected(prefix)
signal root_detected(root)
signal suffix_detected(suffix)
