extends Node

var Fuel = 300
var MaxFuel = 300
var RegenRate = 40
var bIsBeingUsed = false
var bIsOverworked = false

func CanUse():
	return Fuel > 0 and bIsOverworked == false
		
func IsBeingUsed():
	return bIsBeingUsed
	
func Use(delta, rate = 50):
	Fuel -= rate * delta
	bIsBeingUsed = true
	if Fuel <= 0:
		bIsOverworked = true
		var explodeParticle = load("res://Prefab/ExplodeParticle.tscn")
		var instance = explodeParticle.instantiate()
		instance.global_position = Finder.GetPlayer().global_position
		Finder.GetEffectsGroup().add_child(instance)

func Replenish():
	Fuel = MaxFuel
	
func RegenByAmount(amount):
	Fuel += amount
	Regen(0)
	
func Regen(delta):
	Fuel += RegenRate * delta
	if Fuel > MaxFuel:
		Fuel = MaxFuel
		bIsOverworked = false
	bIsBeingUsed = false
	
func GetProgress():
	return float(Fuel) / float(MaxFuel)

func IsFull():
	return MaxFuel == Fuel
