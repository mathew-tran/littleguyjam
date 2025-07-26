extends Node

func GetGame() -> Game:
	return get_tree().get_nodes_in_group("Game")[0]
	
func GetPlayer() -> Player:
	return get_tree().get_nodes_in_group("Player")[0]
