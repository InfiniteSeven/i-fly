extends CharacterBody3D

@export_group("Missle Knows")
@export var z_wing_pos : Vector3
@export var new_z_pos : Vector3
@export var old_z_pos : Vector3
@export var fut_z_pos : Vector3
@export var z_wing_node = z_wing
@export var speed = 200
@export var turn_speed = 0.04
@onready var box = $Box
@onready var head = $Head

@export_group("Speeds")
@export var forward_speed = 0.0
@export var roll_speed = 0.0
@export var pitch_speed = 0.0
@export var yaw_speed = 0.0
@export var combined_speed = 0.0
@export var speed_r = 0.0
@export var speed_p = 0.0
@export var speed_y = 0.0
var gravity = 1


var throttle : float

func _ready():
	pass

func _physics_process(delta: float) -> void:

	#new_z_position = get_parent().get_parent().$"Z-Wing".position
	#print (new_z_position)

#engine
	$CSGCylinder3D/CSGCylinder3D.material.emission_energy_multiplier = (forward_speed * 0.01)
	$CSGCylinder3D/CSGCylinder3D/SpotLight3D.light_energy = (forward_speed * 0.06)

	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

#movement
	z_wing_pos = get_parent().get_parent().z_position

	var motion = (head.global_basis * Vector3(0, 0, -1)).normalized()
	motion *= speed * delta

	var new_tran = self.transform.looking_at(z_wing_pos-(get_parent().global_position), Vector3.UP)
	self.transform = self.transform.interpolate_with(new_tran, turn_speed)

	#print ("missile " + str($".".position))
	old_z_pos = new_z_pos
	new_z_pos = z_wing_pos
	fut_z_pos = new_z_pos + ((new_z_pos - old_z_pos) * (($MissileLife.time_left) * 2))
	print ($MissileLife.time_left)
	#box.global_position = fut_z_pos
	#if $MissileLife.time_left > 6:
	#	look_at(fut_z_pos)
	#else:
	#	look_at(z_wing_pos)

	move_and_collide(motion)
	#move_and_slide()

#z-wing





#combined speed
	speed_p = pitch_speed
	speed_r = roll_speed
	speed_y = yaw_speed
	if speed_p < 0:
		speed_p *= -1
	if speed_r < 0:
		speed_r *= -1
	if speed_y < 0:
		speed_y *= -1

	combined_speed = 200 - ((speed_p + speed_y)*10)

#forward
	throttle = Input.get_action_strength("throttle")

	if Input.is_action_pressed("throttle"):
		if forward_speed < combined_speed :
			forward_speed += 0.5 * throttle
		elif forward_speed > combined_speed:
			forward_speed -= 0.2
	else:
		if forward_speed > 0:
			forward_speed -= 0.1

	if Input.is_action_pressed("throttle"):
		if forward_speed < 15:
			forward_speed += 0.1
	else:
		if forward_speed > 0:
			forward_speed -= 0.01


func expire():
	$".".queue_free()
