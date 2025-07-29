extends Label

func _ready() -> void:
	Finder.GetGame().OnTimeUpdate.connect(OnTimeUpdate)
	
func OnTimeUpdate(amount):
	text = str(amount) + "s"
