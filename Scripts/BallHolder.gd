extends Node2D

class_name BallHolder

var BallClass = load("res://Prefab/Ball.tscn")

var MaxBallAmount = 5

func HasReachedCapacity():
	return get_child_count() >= MaxBallAmount
	
func _ready() -> void:
	UpdateBody()

func UpdateBody():
	await get_tree().create_timer(.1).timeout
	var balls = get_children()
	for index in range(0, balls.size()):
		if index == 0:
			balls[index].FollowObject = Finder.GetPlayer()
		else:
			balls[index].FollowObject = balls[index-1]
			

func _on_child_exiting_tree(node: Node) -> void:
	UpdateBody()


func _on_child_entered_tree(node: Node) -> void:
	UpdateBody()

func HasBalls():
	return get_child_count() > 0
	
func AddBall():
	var ball = BallClass.instantiate()
	ball.global_position = Finder.GetPlayer().global_position
	add_child(ball)

func RemoveBall():
	if HasBalls():
		get_child(0).queue_free()
