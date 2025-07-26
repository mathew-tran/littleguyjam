extends Node2D

var Rooms : Array[LevelBase]
var RoomCount = 4

var LevelClass = load("res://Scenes/Levels/Level1.tscn")
func _ready() -> void:
	Rooms.push_back(get_child(0))
	get_child(0).OnExitDoorPassed.connect(OnDoorPassed)
	SpawnNextDoor()
	
func SpawnNextDoor():
	while len(Rooms) >= RoomCount:
		var room = Rooms.pop_front()
		room.queue_free()
	
	var instance = LevelClass.instantiate() as LevelBase
	instance.global_position = Rooms[0].GetExitDoor().GetSpawnPosition()
	
	add_child(instance)
	
	instance.OnExitDoorPassed.connect(OnDoorPassed)
	Rooms.push_back(instance)

	print("room spawned")
	
	instance = LevelClass.instantiate() as LevelBase
	
	
	add_child(instance)
	instance.global_position = Rooms[0].GetExitDoor().GetSpawnPosition()
	instance.OnExitDoorPassed.connect(OnDoorPassed)
	Rooms.push_back(instance)
	print("room spawned")
		
	
func OnDoorPassed(door : Door):
	SpawnNextDoor()
	print("OnExitDoorPassed")
	
