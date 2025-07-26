extends Area2D

class_name Door

enum DOOR_TYPE {
	ENTRY,
	EXIT
}

@export var DoorType : DOOR_TYPE

signal OnDoorPassed(door)

var bIsUsed = false

func _ready() -> void:
	if DoorType == DOOR_TYPE.ENTRY:
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	if bIsUsed:
		return
	
	if body is Player:
		bIsUsed = true
		OnDoorPassed.emit(self)
		
func GetSpawnPosition():
	return $SpawnPosition.global_position
