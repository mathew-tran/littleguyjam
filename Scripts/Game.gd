extends Node2D

class_name Game

var Points = 0
var Health = 3
var MaxHealth = 3
var LastCheckPointPosition = Vector2.ZERO

signal OnPointAdded(amount)
signal OnHealthUpdate
signal OnHealthMaxUpdate
signal OnGameOver

func _ready() -> void:
	OnHealthMaxUpdate.emit()
	Jukebox.PlayMusic(JukeboxPlayer.MUSIC_TYPE.LEVEL_1)
	
func Slomo(amount, time, recoverTime = .1):
	if Engine.time_scale != 1:
		return
	Engine.time_scale = amount
	await get_tree().create_timer(time).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", 1, recoverTime)
	await tween.finished
	Engine.time_scale = 1
	
func AddPoints(amount):
	Points += amount
	OnPointAdded.emit(Points)
	var pointText = "+{points}".format({
		"points" : str(amount)
	})
	Helper.CreateText(Finder.GetPlayer().global_position, pointText, PopupText.POPUP_TYPE.NORMAL)
	
func TakeDamage():
	Health -= 1
	OnHealthUpdate.emit()
	if Health <= 0:
		Finder.GetPlayer().Die()
		Jukebox.PlayMusic(JukeboxPlayer.MUSIC_TYPE.GAME_OVER)
		OnGameOver.emit()
	else:
		Finder.GetPlayer().MovePlayer(LastCheckPointPosition)
func SetCheckpointPosition(pos):
	LastCheckPointPosition = pos

func IsPickupLayer(body):
	return body.is_in_group("Pickup")
func AttemptCoinPickup(body, body_rid):
	if body is TileMapLayer:
		if body.is_in_group("Pickup"):
			var coords =  body.get_coords_for_body_rid(body_rid)
			var tile = body.get_cell_tile_data(coords)
			if tile:
				if tile.get_custom_data("PickupType") == "Coin":
					body.set_cell(coords)
					Finder.GetGame().AddPoints(100)
					Jukebox.PlayCollectSFX()
