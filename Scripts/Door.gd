extends Area2D

class_name Door

enum DOOR_TYPE {
	ENTRY,
	EXIT
}

@export var DoorType : DOOR_TYPE

signal OnDoorPassed(door)

var bIsUsed = false

func _enter_tree() -> void:
	visible = false
func _ready() -> void:
	pass
		
func _on_body_entered(body: Node2D) -> void:
	if bIsUsed:
		return
	if DoorType == DOOR_TYPE.ENTRY:
		return
	
	if body is Player:
		bIsUsed = true
		OnDoorPassed.emit(self)
		
func GetSpawnPosition():
	return $SpawnPosition.global_position

func GetDrawTilePositions():
	return [
		$DrawTile.global_position,
		$DrawTile2.global_position
	]
