extends Node2D

class_name LevelBase

signal OnExitDoorPassed(door)

func _ready() -> void:
	$ExitDoor.OnDoorPassed.connect(OnDoorPassed)	
	
func GetExitDoor():
	return $ExitDoor
	
func OnDoorPassed(door):
	OnExitDoorPassed.emit($ExitDoor)
