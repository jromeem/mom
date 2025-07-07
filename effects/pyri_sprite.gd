extends AnimatedSprite2D

var seq_pointer = 0;
var sequence = ["pyri_start", "pyri_loop", "pyri_end"]

func _physics_process(_delta):
	if (seq_pointer >= sequence.size()):
		queue_free()
		return

	play(sequence[seq_pointer])

func _on_animation_finished() -> void:
	seq_pointer += 1
