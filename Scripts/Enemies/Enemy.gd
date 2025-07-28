extends CharacterBody2D

class_name Enemy

enum ENEMY_STATE {
	MOVE_LEFT,
	MOVE_RIGHT
}

@export var CurrentState = ENEMY_STATE.MOVE_RIGHT
@export var MoveSpeed = 200
@export var PointAmount = 200
@export var Gravity = 0

@onready var Raycast = $CollisionShape2D/TextureRect/RayCast2D

@export var Health = 1
			
func _physics_process(delta: float) -> void:
	if Raycast.get_collider():
		SwitchDirection()
	var newVelocity = velocity
	match CurrentState:
		ENEMY_STATE.MOVE_LEFT:
			newVelocity.x = -MoveSpeed
		ENEMY_STATE.MOVE_RIGHT:
			newVelocity.x = MoveSpeed
	newVelocity.y = Gravity
	velocity = newVelocity
	move_and_slide()

func SwitchDirection():
	print("switch")
	match CurrentState:
			ENEMY_STATE.MOVE_LEFT:
				CurrentState = ENEMY_STATE.MOVE_RIGHT
				$CollisionShape2D/TextureRect.scale = Vector2.ONE
				
			ENEMY_STATE.MOVE_RIGHT:
				CurrentState = ENEMY_STATE.MOVE_LEFT
				$CollisionShape2D/TextureRect.scale = Vector2(-1, 1)

func TakeDamage():
	Health -= 1
	if Health <= 0:
		Finder.GetGame().AddPoints(PointAmount)
		queue_free()				
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.TakeDamage()


func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(2, 5)
	$Timer.start()
	$AudioStreamPlayer2D.play()
