extends CharacterBody2D

var FollowObject : Node2D
var LastDirection = Vector2.RIGHT
var Speed = 1000
var MaxSpeed = 1000000

var MaxDistance = 10000
func _process(delta: float) -> void:
	if FollowObject:
		var followObjectPosition = FollowObject.global_position
		
		var distance = global_position.distance_to(followObjectPosition)
		distance = clamp(distance, 0, 10000)
		var speed = lerp(Speed, MaxSpeed, distance / MaxDistance)
		
			

		velocity *= .8

		if global_position.distance_to(followObjectPosition) > 100:			
			var dir = (followObjectPosition - global_position).normalized()
			LastDirection = dir
		else:
			speed = 0
		
		velocity += LastDirection * speed * delta
		$Sprite2D.flip_h = velocity.x <= 0
		move_and_slide()
	
