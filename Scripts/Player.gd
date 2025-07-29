extends RigidBody2D

class_name Player

var Eyes = []

var MoveSpeed = 800
var MaxLength = 520
@onready var TongueEndClass = preload("res://Prefab/TongueEnd.tscn")
@onready var BulletClass = preload("res://Prefab/FlyBullet.tscn")
var TongueEndRef = null

var bCanMove = true
var bIsDead = false

var bCanTakeDamage = true

func _ready():
	ChangeMouth(false)
	Eyes.append($TextureRect/EyeLeft)
	Eyes.append($TextureRect/EyeRight)

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
	if $Engine.IsFull():
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
	$ProgressBar.value = $Engine.GetProgress()
	$ProgressBar.modulate = lerp(Color.WHITE, Color.RED, 1 - $Engine.GetProgress())
	
	if $Engine.CanUse() == false:
		apply_impulse(Vector2.DOWN * 1500 * delta)
		linear_damp = .2
		$TextureRect.scale = Vector2.ONE
		$TextureRect.modulate = Color.RED
		RevertTongue()
	else:
		$TextureRect.modulate = Color.WHITE
	if CanMove() == false:
		return
		
	UpdateEyes(delta)		
		
	if Input.is_action_just_released("Click"):
		RevertTongue()
		
	if Input.is_action_just_pressed("Pop"):
		if $Engine.CanUse():
			$PlayerResettingSFX.play()
			
	if Input.is_action_just_released("Pop"):
		$PlayerResettingSFX.stop()
		$TextureRect.scale = Vector2.ONE
		
	if Input.is_action_pressed("Pop"):
		if $Engine.CanUse():
			var progress = $Engine.GetProgress()
			var pitch = lerp(.7, 1.2, progress)
			$PlayerResettingSFX.pitch_scale = pitch
			$Engine.Use(delta, 120)
			$TextureRect.scale = (Vector2.ONE * lerp(1.0, 1.75, 1 - progress))
			apply_impulse(Vector2.UP * 1200 * delta )

	
	if Input.is_action_just_pressed("Shoot"):
		if Finder.GetBallHolder().HasBalls():
			$Engine.Use(delta, 10)
			Finder.GetBallHolder().RemoveBall()
			var instance = BulletClass.instantiate()
			instance.global_position = global_position
			instance.Direction = (get_global_mouse_position() - global_position).normalized()
			Finder.GetEffectsGroup().add_child(instance)
	if Input.is_action_pressed("Click") and CanUseTongue() and HasTongue() == false:
		$TongueCooldown.start()
		$AudioStreamPlayer2D.play()
		RevertTongue()
		
		var direction = to_local(get_global_mouse_position()).normalized()
		$RayCast2D.target_position = direction * MaxLength
		$RayCast2D.force_raycast_update()
		
		TongueEndRef = TongueEndClass.instantiate()
		TongueEndRef.OwnerObject = self
		TongueEndRef.MaxLength = MaxLength
		
		
		ChangeMouth(true)
		if $RayCast2D.is_colliding():	
		
			TongueEndRef.global_position = $RayCast2D.get_collision_point()
			TongueEndRef.get_node("PinJoint2D").node_b = get_path()
			get_parent().add_child(TongueEndRef)
			TongueEndRef.SetupInitialTracking($RayCast2D.get_collision_point(), $RayCast2D.get_collider().get_path())
			angular_velocity = 0
			$RayCast2D.enabled = false
			TongueEndRef.EmitParticle()
			
			if $RayCast2D.get_collider() is FlyPickup:
				await $RayCast2D.get_collider().Pickup()
				return
		else:
			TongueEndRef.global_position = to_global($RayCast2D.target_position)
			get_parent().add_child(TongueEndRef)
	
	
func _physics_process(delta):
	if $GroundCheck.get_overlapping_bodies():
		$Engine.Regen(delta)
	if CanMove():
		Move(delta)
		
		
func IsConnected():
	return 
		
func Move(delta):
	var multiplier = 1
	if HasTongue():
		multiplier *= 2
		linear_damp = .5
		$Engine.Use(delta, 40)
	else:
		if $GroundCheck.get_overlapping_bodies():
			linear_damp = 1
		else:
			if $Engine.IsBeingUsed():
				linear_damp = 3
			else:
				linear_damp = 2
	if Input.is_action_pressed("MoveLeft"):
		apply_impulse(Vector2.LEFT * MoveSpeed * delta * multiplier)
	if Input.is_action_pressed("MoveRight"):
		apply_impulse(Vector2.RIGHT * MoveSpeed * delta * multiplier)

func CanUseTongue():
	return $TongueCooldown.time_left == 0.0 and bCanTakeDamage
	
func HasTongue():
	return is_instance_valid(TongueEndRef)
	
	
func CanMove():
	return bCanMove and bIsDead == false and $Engine.CanUse()
	
func _input(event):
	if CanMove() == false:
		return
		

func ChangeMouth(bIsUsed):
	if bIsUsed:
		$TextureRect/Mouth.texture = load("res://Art/Player/Mouth.png")
	else:
		$TextureRect/Mouth.texture = load("res://Art/Player/ClosedMouth.png")
		
func RevertTongue():
	$RayCast2D.target_position = Vector2.ZERO

	$RayCast2D.force_raycast_update()
	if is_instance_valid(TongueEndRef):
		TongueEndRef.Kill()
	ChangeMouth(false)


func _on_tongue_cooldown_timeout():
	if IsConnected() == false:
		RevertTongue()
		$RayCast2D.enabled = true


func Pop():
	FreezeBody()
	if HasTongue():
		TongueEndRef.queue_free()
	var tween = get_tree().create_tween()
	$CPUParticles2D.restart()
	tween.tween_property(self, "modulate", Color.RED, .1)
	tween.tween_property(self, "scale", Vector2(2,2), .2)

	await tween.finished
	modulate = Color(0,0,0,0)
	await get_tree().create_timer(.3).timeout	

	
func PopIn():
	scale = Vector2.ZERO
	angular_velocity = 0
	linear_velocity = Vector2.ZERO
	$CPUParticles2D.restart()
	var tween = get_tree().create_tween()
	modulate = Color.WHITE
	tween.tween_property(self, "scale", Vector2(1,1), .2)
	await tween.finished
	
	await get_tree().create_timer(.3).timeout	
	
func Die():
	bCanTakeDamage = false
	Pop()
	
func Replenish():
	$Engine.Replenish()

func GetEngine():
	return $Engine
	
func MovePlayer(pos):
	Replenish()
	Finder.GetGame().Slomo(.3, .1, .001)
	bCanTakeDamage = false
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
		Jukebox.PlaySFX(load("res://Audio/SFX/death.wav"), Finder.GetPlayer().global_position)

	
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		if body.is_in_group("Spikes"):
			TakeDamage()
			

func _on_pickup_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		Finder.GetGame().AttemptCoinPickup(body, body_rid)
