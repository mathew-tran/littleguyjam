extends Node2D

@onready var FlyClass = preload("res://Prefab/Pickup/FlyPickup.tscn")

func _on_timer_timeout() -> void:
	if Finder.GetBallHolder().HasReachedCapacity():
		return
		
	if Finder.GetPlayer().global_position.distance_to(global_position) > 300:
		return
	$Timer.stop()
	$AnimationPlayer.play("anim")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var instance = FlyClass.instantiate()
	
	add_child(instance)
	instance.global_position = $SpawnPosition.global_position
	$Timer.start()
