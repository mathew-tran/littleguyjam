extends AudioStreamPlayer

class_name JukeboxPlayer

enum MUSIC_TYPE {
	NONE,
	CONTINUE,
	LEVEL_1,
	GAME_OVER,
}

var SoundChannels = [
	]

func _ready() -> void:
	SoundChannels.append(self)
	ChangeAudio(-1000)
	PlayMusic(MUSIC_TYPE.NONE)

func ChangeAudio(volumeDB):
	for channel in SoundChannels:
		channel.volume_db = volumeDB
	
	
func Resume(channel : AudioStreamPlayer):
	
	if channel.get_playback_position() == 0.0:
		channel.volume_db = -20
		channel.play()
	else:
		channel.volume_db = -100
		channel.play(channel.get_playback_position())
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(channel, "volume_db", -20, .1)

func Stop(channel):
	if channel.stream_paused or channel.playing == false:
		return
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(channel, "volume_db", -1000, .1)
	await tween.finished
	channel.stream_paused = true
	
		
func PlayMusic(musicType : MUSIC_TYPE):
	print("PLAY: " + str(MUSIC_TYPE.keys()[musicType]))
	await Stop(self)
	await Stop($DeadMusic)
	
	match musicType:
		MUSIC_TYPE.LEVEL_1:
			Resume(self)
		MUSIC_TYPE.GAME_OVER:
			Resume($DeadMusic)
		MUSIC_TYPE.NONE:
			ChangeAudio(-10000)
			pass
		MUSIC_TYPE.CONTINUE:
			return

	
func PlaySFX(audiostream : AudioStream, position = Vector2.ZERO, channel = 0):
	var audioPlayer = $SFX
	if channel == 1:
		audioPlayer = $SFX2
	if audiostream:
		audioPlayer.global_position = position
		audioPlayer.stream = audiostream
		audioPlayer.play()
		
func PlayCollectSFX():
	$CollectSFX.pitch_scale = randf_range(0.8, 1.2)
	$CollectSFX.global_position =  Finder.GetPlayer().global_position
	$CollectSFX.play()
