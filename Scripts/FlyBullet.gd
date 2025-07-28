extends Area2D

var Direction = Vector2.ZERO
var Speed = 3000

var bCanDie = false

func _ready() -> void:
	await get_tree().create_timer(.01).timeout
	bCanDie = true
	rotation = Direction.angle()
func _process(delta: float) -> void:
	global_position += Direction * Speed * delta


func _on_body_entered(body: Node2D) -> void:
	if bCanDie == false:
		return
	Jukebox.PlaySFX(load("res://Audio/SFX/ant-1.wav"), global_position)
	var explodeParticle = load("res://Prefab/ExplodeParticle.tscn")
	var instance = explodeParticle.instantiate()
	instance.global_position = global_position
	Finder.GetEffectsGroup().add_child(instance)
	force_update_transform()
	var bodies = get_overlapping_bodies()
	for subbody in bodies:
		if subbody is Enemy:
			subbody.TakeDamage()
	queue_free()
