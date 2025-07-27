extends Node

var PopupClass = load("res://Prefab/UI/TextPopup.tscn")

func CreateText(pos, text, type : PopupText.POPUP_TYPE):
	var instance = PopupClass.instantiate() as PopupText
	Finder.GetEffectsGroup().add_child(instance)
	instance.global_position = pos
	instance.Setup(text, type)
