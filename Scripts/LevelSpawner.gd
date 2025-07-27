extends Node2D

var Rooms : Array[LevelBase]
var RoomCount = 8

var Levels = [
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	"res://Scenes/Levels/LevelEnd.tscn"]
func _ready() -> void:
	Rooms.push_back(get_child(0))
	get_child(0).OnExitDoorPassed.connect(OnDoorPassed)
	await SpawnNextDoor()

func GetNextLevel():
	if len(Levels) == 0:
		return null
	return load(Levels.pop_front())
	
	
func SpawnNextDoor():
	while len(Rooms) >= RoomCount:
		var room = Rooms.pop_front()
		room.queue_free()
		print("room removed")
	
	await get_tree().create_timer(0.1).timeout
	var nextLevel = GetNextLevel()
	if nextLevel == null:
		print("GAME OVER")
		return
	var instance = nextLevel.instantiate() as LevelBase
	instance.global_position = Rooms.back().GetExitDoor().GetSpawnPosition()
	
	call_deferred("add_child", instance)
	
	instance.OnExitDoorPassed.connect(OnDoorPassed)
	Rooms.push_back(instance)

	print("room spawned")
		
	
func OnDoorPassed(door : Door):
	SpawnNextDoor()
	print("OnExitDoorPassed" + door.name)
	
