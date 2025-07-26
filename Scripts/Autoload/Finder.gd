extends Node

func GetGame() -> Game:
	return get_tree().get_nodes_in_group("Game")[0]
	
