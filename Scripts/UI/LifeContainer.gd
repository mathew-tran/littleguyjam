extends HBoxContainer

func _ready() -> void:
	Finder.GetGame().OnHealthUpdate.connect(OnHealthUpdate)
	Finder.GetGame().OnHealthMaxUpdate.connect(OnHealthMaxUpdate)
	
func OnHealthUpdate():
	var health = Finder.GetGame().Health
	for x in range(0, Finder.GetGame().MaxHealth):
		if health > x:
			get_child(x).modulate = Color.WHITE
		else:
			get_child(x).modulate = Color.BLACK
		
func OnHealthMaxUpdate():
	var health = Finder.GetGame().MaxHealth
	while get_child_count() < health:
		var instance = load("res://Prefab/UI/LifeIcon.tscn").instantiate()
		add_child(instance)
		await get_tree().process_frame
