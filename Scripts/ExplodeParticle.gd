extends CPUParticles2D

func _enter_tree() -> void:
	one_shot = false
	emitting = false
	
func _ready() -> void:
	one_shot = true
	emitting = true
	var tongue = Finder.GetTongue()
	if tongue:
		if global_position.distance_to(tongue.global_position) < 200:
			tongue.Kill()
	

func _on_finished() -> void:

	queue_free()
