extends CPUParticles2D

func _enter_tree() -> void:
	one_shot = false
	emitting = false
	
func _ready() -> void:
	one_shot = true
	emitting = true
	

func _on_finished() -> void:
	queue_free()
