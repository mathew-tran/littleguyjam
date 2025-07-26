extends Label

func _ready() -> void:
	Finder.GetGame().OnPointAdded.connect(OnPointAdded)
	OnPointAdded(0)
	
func OnPointAdded(points):
	text = str(points).pad_zeros(10)
