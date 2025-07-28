extends Area2D

enum SPIKE_STATE {
	HANGING,
	WIGGLING,
	FALLING,
}
var CurrentState =  SPIKE_STATE.HANGING
var FallSpeed = 3600
func _process(delta: float) -> void:
	if CurrentState == SPIKE_STATE.HANGING:
		if $RayCast2D.is_colliding():
			CurrentState = SPIKE_STATE.WIGGLING
			Jukebox.PlaySFX(load("res://Audio/SFX/stick.wav"), global_position)
			await get_tree().create_timer(.2).timeout
			CurrentState = SPIKE_STATE.FALLING
	if CurrentState == SPIKE_STATE.FALLING:
		global_position += Vector2(0, FallSpeed) * delta
		force_update_transform()
		


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.TakeDamage()
	else:
		var explodeParticle = load("res://Prefab/ExplodeParticle.tscn")
		var instance = explodeParticle.instantiate()
		Jukebox.PlaySFX(load("res://Audio/SFX/death.wav"), global_position)
		instance.global_position = global_position
		Finder.GetEffectsGroup().add_child(instance)
		queue_free()
