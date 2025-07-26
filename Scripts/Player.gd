extends RigidBody2D

class_name Player

var Eyes = []

var MoveSpeed = 600
var MaxLength = 600
@onready var TongueEndClass = preload("res://Prefab/TongueEnd.tscn")
var TongueEndRef = null

var bCanMove = true
var bIsDead = false

var bCanTakeDamage = true

func _ready():
	pass

func FreezeBody():
	freeze = true
	for child in get_children():
		if child is RigidBody2D:
			child.freeze = true
			
	if HasTongue():
		TongueEndRef.bEnabled = false

func UnfreezeBody():
	freeze = false
	for child in get_children():
		if child is RigidBody2D:
			child.freeze = true
			
	if HasTongue():
		TongueEndRef.bEnabled = true
	
func UpdateEyes(delta):
	for eye in Eyes:
		if eye:
			eye.look_at(get_global_mouse_position())	
	
func _process(delta):
	if CanMove() == false:
		return
		
	UpdateEyes(delta)		
		
	if Input.is_action_just_released("Click"):
		RevertTongue()
		
	if Input.is_action_pressed("Click") and CanUseTongue() and HasTongue() == false:
		$TongueCooldown.start()
		RevertTongue()
		
		var direction = to_local(get_global_mouse_position()).normalized()
		$RayCast2D.target_position = direction * MaxLength
		$RayCast2D.force_raycast_update()
		
		TongueEndRef = TongueEndClass.instantiate()
		TongueEndRef.OwnerObject = self
		TongueEndRef.MaxLength = MaxLength
		get_parent().add_child(TongueEndRef)
		
		if $RayCast2D.is_colliding():			
			TongueEndRef.global_position = $RayCast2D.get_collision_point()
			TongueEndRef.get_node("PinJoint2D").node_b = get_path()
			TongueEndRef.SetupInitialTracking($RayCast2D.get_collision_point(), $RayCast2D.get_collider().get_path())
			angular_velocity = 0
			$RayCast2D.enabled = false
			TongueEndRef.EmitParticle()
		else:
			TongueEndRef.global_position = to_global($RayCast2D.target_position)
			
	
	
func _physics_process(delta):
	if CanMove():
		Move(delta)
		
func IsConnected():
	return 
		
func Move(delta):
	var multiplier = 1
	if HasTongue():
		multiplier *= 2
	if Input.is_action_pressed("MoveLeft"):
		apply_impulse(Vector2.LEFT * MoveSpeed * delta * multiplier)
	if Input.is_action_pressed("MoveRight"):
		apply_impulse(Vector2.RIGHT * MoveSpeed * delta * multiplier)

func CanUseTongue():
	return $TongueCooldown.time_left == 0.0 and bCanTakeDamage
	
func HasTongue():
	return is_instance_valid(TongueEndRef)
	
	
func CanMove():
	return bCanMove and bIsDead == false
	
func _input(event):
	if CanMove() == false:
		return
		

		
func RevertTongue():
	$RayCast2D.target_position = Vector2.ZERO

	$RayCast2D.force_raycast_update()
	if is_instance_valid(TongueEndRef):
		TongueEndRef.Kill()


func _on_tongue_cooldown_timeout():
	if IsConnected() == false:
		RevertTongue()
		$RayCast2D.enabled = true

func Die():
	if bIsDead:
		return
		
	bIsDead = true
	
	FreezeBody()
	if HasTongue():
		TongueEndRef.queue_free()
		
		
	

	get_tree().reload_current_scene()

func Pop():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(2,2), .2)
	await tween.finished
	modulate = Color(0,0,0,0)
	await get_tree().create_timer(.3).timeout	
	
func PopIn():
	scale = Vector2.ZERO
	angular_velocity = 0
	linear_velocity = Vector2.ZERO
	var tween = get_tree().create_tween()
	modulate = Color.WHITE
	tween.tween_property(self, "scale", Vector2(1,1), .2)
	await tween.finished
	
	await get_tree().create_timer(.3).timeout	
	
func MovePlayer(pos):
	bCanTakeDamage = false
	if HasTongue():
		TongueEndRef.queue_free()
	FreezeBody()
	await Pop()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, .3)
	
	await tween.finished
	UnfreezeBody()
	await PopIn()
	
	bCanTakeDamage = true
	
func TakeDamage():
	if bCanTakeDamage:
		Finder.GetGame().TakeDamage()

	
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		if body.is_in_group("Spikes"):
			TakeDamage()

func _on_pickup_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		if body.is_in_group("Pickup"):
			var coords =  body.get_coords_for_body_rid(body_rid)
			var tile = body.get_cell_tile_data(coords)
			if tile:
				if tile.get_custom_data("PickupType") == "Coin":
					body.set_cell(coords)
					Finder.GetGame().AddPoints(100)
