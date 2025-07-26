extends StaticBody2D

var OwnerObject = null

var bIsKilled = false

var Progress = 0.0

var PullSpeed = 1000

var bInitialImpulse = false
var MaxLength = 200

var bEnabled = true
var CollisionPosition = Vector2.ZERO
var LocalOffset = Vector2.ZERO
var LocalRotationOffset : float

func SetupInitialTracking(trackedPosition, connectionJointPath):
	$ConnectionJoint.node_b = connectionJointPath
	CollisionPosition = trackedPosition
	LocalOffset = GetSurface().to_local(CollisionPosition)
	LocalRotationOffset = global_rotation - GetSurface().global_rotation
	
func UpdateTrackingPosition():
	var scaledOffset = LocalOffset
	var rotatedOffset = scaledOffset.rotated(GetSurface().global_rotation)
	global_position = GetSurface().global_position + rotatedOffset
	global_rotation = GetSurface().global_rotation + LocalRotationOffset

func GetSurface():
	return get_node($ConnectionJoint.node_b)
	
func _process(delta):
	if bEnabled == false:
		return
	$Line2D.points[1] = to_local(OwnerObject.global_position)
	if bIsKilled:
		Progress += delta * 40
		$Line2D.points[0] = to_local(lerp(self.global_position, OwnerObject.global_position, Progress))
		$Sprite2D.visible = false
		if Progress >= 1:
			queue_free()
	else:
		$Line2D.points[0] = to_local(self.global_position)
		if $PinJoint2D.node_b != OwnerObject.get_path() or get_node_or_null($ConnectionJoint.node_b) == null:
			if $KillTimer.time_left == 0.0:
				$KillTimer.start()
				$Line2D.width *= .5
		else:
			$Line2D.default_color = Color.RED
			$Sprite2D.modulate = Color.RED
			UpdateTrackingPosition()
	
func EmitParticle():
	$CPUParticles2D.emitting = true
	$AudioStreamPlayer2D.play()
			
func _physics_process(delta):
	if bEnabled == false:
		return
	if $PinJoint2D.node_b != OwnerObject.get_path():
		return
		
	var speed = PullSpeed
	if bInitialImpulse:
		speed *= 10
		
	if Input.is_action_pressed("Down"):
		IncreaseTongueLength(speed * delta)
	elif Input.is_action_pressed("Up"):
		DecreaseTongueLength(speed * delta)

	else:
		bInitialImpulse = true
	
	
func IncreaseTongueLength(amount):
	if global_position.distance_to(OwnerObject.global_position) >= MaxLength:
		return
	$PinJoint2D.node_b = get_path()
	var direction = (OwnerObject.global_position - global_position).normalized()
	OwnerObject.global_position += direction * 20
	bInitialImpulse = false
	$PinJoint2D.node_b = OwnerObject.get_path()
	
func DecreaseTongueLength(amount):
	if global_position.distance_to(OwnerObject.global_position) <= 100:
		return
	$PinJoint2D.node_b = get_path()
	var direction = (OwnerObject.global_position - global_position).normalized()
	OwnerObject.global_position += direction * -20
	bInitialImpulse = false	
	$PinJoint2D.node_b = OwnerObject.get_path()
	
func _on_kill_timer_timeout():
	Kill()

func Kill():
	if bIsKilled:
		return
	bIsKilled = true

			
