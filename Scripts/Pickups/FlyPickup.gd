extends RigidBody2D

class_name FlyPickup

func _ready() -> void:
	$AnimationPlayer.play("anim")




func Pickup():
	$CollisionShape2D.queue_free()
	await get_tree().process_frame
	
	var tween = get_tree().create_tween()	

	Finder.GetPlayer().RevertTongue()
	tween.tween_property(self, "global_position", Finder.GetPlayer().global_position, .2)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.texture = load("res://Art/Pickups/FlyBall.png")
	
	await tween.finished
	Finder.GetBallHolder().AddBall()
	queue_free()
