extends Node2D

class_name Game

var Points = 0

signal OnPointAdded(amount)

func AddPoints(amount):
	Points += amount
	OnPointAdded.emit(Points)
