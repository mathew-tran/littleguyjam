extends Node2D

class_name PopupText

enum POPUP_TYPE {
	NORMAL
}
func _enter_tree() -> void:
	visible = false
	
func Setup(text, popupType : POPUP_TYPE):
	$Label.text = text
	visible = true
	if popupType == POPUP_TYPE.NORMAL:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", global_position - Vector2(0, 40), .1)
		await tween.finished
		await get_tree().create_timer(.5).timeout
		queue_free()
