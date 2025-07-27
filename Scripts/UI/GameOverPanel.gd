extends Panel

func _ready() -> void:
	Finder.GetGame().OnGameOver.connect(OnGameOver)
	
func OnGameOver():
	visible = true
	
func _on_button_button_up() -> void:
	get_tree().reload_current_scene()
