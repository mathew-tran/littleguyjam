extends Node2D

enum FLAG_STATE {
	NOT_RAISED,
	RAISED
}

var FlagState = FLAG_STATE.NOT_RAISED

func _on_area_2d_body_entered(body: Node2D) -> void:
	if FlagState == FLAG_STATE.RAISED:
		return
		
	if body is Player:
		FlagState = FLAG_STATE.RAISED
		$AnimationPlayer.play("anim")
		Finder.GetGame().SetCheckpointPosition($SpawnPosition.global_position)
		Finder.GetGame().AddPoints(500)
		$CheckPointSFX.play()
		Helper.CreateText(global_position, "CHECKPOINT!", PopupText.POPUP_TYPE.NORMAL)
