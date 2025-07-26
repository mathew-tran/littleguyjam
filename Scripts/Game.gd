extends Node2D

class_name Game

var Points = 0
var Health = 3
var MaxHealth = 3
var LastCheckPointPosition = Vector2.ZERO

signal OnPointAdded(amount)
signal OnHealthUpdate
signal OnHealthMaxUpdate

func _ready() -> void:
	OnHealthMaxUpdate.emit()
	
func AddPoints(amount):
	Points += amount
	OnPointAdded.emit(Points)
	
func TakeDamage():
	Health -= 1
	if Health <= 0:
		get_tree().reload_current_scene()
	else:
		Finder.GetPlayer().MovePlayer(LastCheckPointPosition)
		OnHealthUpdate.emit()
func SetCheckpointPosition(pos):
	LastCheckPointPosition = pos
