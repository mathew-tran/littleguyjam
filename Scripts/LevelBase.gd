extends Node2D

class_name LevelBase

signal OnExitDoorPassed(door)

func _ready() -> void:
	$ExitDoor.OnDoorPassed.connect(OnDoorPassed)
	$Flag.OnFlagRaised.connect(OnFlagRaised)
	
func GetExitDoor():
	return $ExitDoor
	
func OnDoorPassed(door):
	OnExitDoorPassed.emit($ExitDoor)
	

func OnFlagRaised():
		
	Jukebox.PlaySFX(load("res://Audio/SFX/wallcavein.wav"), Finder.GetPlayer().global_position, 1)
	for tilePos in $EntryDoor.GetDrawTilePositions():
		var localPos = $TileMapLayer.to_local(tilePos)
		var coords = $TileMapLayer.local_to_map(localPos)
		var cellData = $TileMapLayer.get_cell_atlas_coords(coords)
		$TileMapLayer.set_cell(coords, 0, Vector2i(0,0), 0)
		$TileMapLayer.queue_redraw()
		await get_tree().create_timer(.2).timeout
	
