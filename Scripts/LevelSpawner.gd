extends Node2D

var Rooms : Array[LevelBase]
var RoomCount = 8

var LevelClass = load("res://Scenes/Levels/Level1.tscn")
func _ready() -> void:
	Rooms.push_back(get_child(0))
	get_child(0).OnExitDoorPassed.connect(OnDoorPassed)
	await SpawnNextDoor()

	
func SpawnNextDoor():
	while len(Rooms) >= RoomCount:
		var room = Rooms.pop_front()
		room.queue_free()
		print("room removed")
	
	await get_tree().create_timer(0.1).timeout
	var instance = LevelClass.instantiate() as LevelBase
	instance.global_position = Rooms.back().GetExitDoor().GetSpawnPosition()
	
	call_deferred("add_child", instance)
	
	instance.OnExitDoorPassed.connect(OnDoorPassed)
	Rooms.push_back(instance)

	print("room spawned")
		
	
func OnDoorPassed(door : Door):
	SpawnNextDoor()
	print("OnExitDoorPassed" + door.name)
	
