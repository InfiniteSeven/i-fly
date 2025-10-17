extends CharacterBody3D

class_name z_wing

@onready var radar_counter = 0
@export var warning_number = 50
@export var export_position : Vector3

@export_group("Speeds")
const key_turn_speed = 0.05
const mouse_turn_speed = 0.002
@export var f_speed = 500.0 #forward speed
@export var roll_speed = 0.0
@export var pitch_speed = 0.0
@export var yaw_speed = 0.0
@export var roll_rate = 2.5
@export var pitch_up_rate = 1.0
@export var pitch_down_rate = 1.2
@export var yaw_rate = 5.0
@export var combined_speed = 900.0 #real top speed
@export var top_speed = 1000.0 #must fix!
@export var ideal_speed = 500.0
@export var speed_r = 0.0
@export var speed_p = 0.0
@export var speed_y = 0.0
@export var elevator_l = 0.0
var gravity = 1

@export var true_speed : float
@export var g_speed : float
@export var gp1 : Vector3
@export var gp2 : Vector3


@export var z_volume : float

@onready var movementnode = $MovementNode

@export_group("Movement")
var roll_left
var max_roll_left
var roll_right
var max_roll_right
var pitch_up
var max_pitch_up
var pitch_down
var max_pitch_down
var yaw_left
var max_yaw_left
var yaw_right
var max_yaw_right
@export var throttle : float
@export var throttle_add : float
@export var throttle_sub : float
var brakes


func _ready():
	pass

func _unhandled_input(_event: InputEvent) -> void:
	# Mouse capturing

	if Input.is_action_just_pressed("change camera"):
		if $Head/Camera3D.current == true:
			$Camera3D2.make_current()
		else:
			$Head/Camera3D.make_current()


func _process(_delta) -> void:
	if Input.is_action_pressed("camera up"):
		$Head/Camera3D.rotation_degrees.x += 1
	if Input.is_action_pressed("camera down"):
		$Head/Camera3D.rotation_degrees.x -= 1
	if Input.is_action_pressed("camera left"):
		$Head.rotation_degrees.x += 1
	if Input.is_action_pressed("camera right"):
		$Head.rotation_degrees.x -= 1

func _physics_process(delta: float) -> void:
	export_position = $".".position

#engine
	$MeshInstance3D/Engine.material.emission_energy_multiplier = 2.5 + (throttle * 0.1)
	#$MeshInstance3D/Engine/Engine.light_energy = (throttle * 16)

#roll
	roll_left = Input.get_action_strength("roll left")
	roll_right = Input.get_action_strength("roll right")

	if f_speed < ideal_speed:
		max_roll_left = (f_speed / (ideal_speed / roll_rate))
	else:
		max_roll_left = ((f_speed / (ideal_speed / roll_rate)) - ((f_speed - ideal_speed) / (ideal_speed / roll_rate)) * 2)
	if Input.is_action_pressed("roll left"):
		#print ("max roll left " + str(max_roll_left).pad_decimals(2))
		#print ("roll speed " + str(roll_speed).pad_decimals(2))
		if roll_speed < max_roll_left:
			roll_speed += 0.025 * roll_left
		if roll_speed > max_roll_left:
			roll_speed -= 0.01
	else:
		if roll_speed > 0:
			roll_speed -= 0.02

	if f_speed < ideal_speed:
		max_roll_right = f_speed / (ideal_speed / (roll_rate * -1))
	else:
		max_roll_right = ((f_speed / (ideal_speed / (roll_rate * -1))) + ((f_speed - ideal_speed) / (ideal_speed / roll_rate)) * 2)
	if Input.is_action_pressed("roll right"):
		if roll_speed > max_roll_right:
			roll_speed -= 0.025 * roll_right
		if roll_speed < max_roll_right:
			roll_speed += 0.01
	else:
		if roll_speed < 0:
			roll_speed += 0.02

	global_rotate(transform.basis.y, 1 * roll_speed * delta)

#pitch
	pitch_up = Input.get_action_strength("pitch up")
	pitch_down = Input.get_action_strength("pitch down")

	if f_speed < ideal_speed:
		max_pitch_up = f_speed / (ideal_speed * pitch_up_rate)
	else:
		max_pitch_up = ((f_speed / (ideal_speed * pitch_up_rate)) - ((f_speed - ideal_speed) / (ideal_speed * pitch_down_rate)) * 2)
	if Input.is_action_pressed("pitch up"):
		if pitch_speed < max_pitch_up:
			pitch_speed += 0.01 * pitch_up
		if pitch_speed > max_pitch_up:
			pitch_speed -= 0.01
	else:
		if pitch_speed > 0:
			pitch_speed -= 0.01

	if f_speed < ideal_speed:
		max_pitch_down = f_speed / (ideal_speed * (pitch_down_rate * -1))
	else:
		max_pitch_down = ((f_speed / (ideal_speed * (pitch_down_rate * -1))) + ((f_speed - ideal_speed) / (ideal_speed * pitch_down_rate)) * 2)
	if Input.is_action_pressed("pitch down"):
		if pitch_speed > max_pitch_down:
			pitch_speed -= 0.0075 * pitch_down
		if pitch_speed < max_pitch_down:
			pitch_speed += 0.01
	else:
		if pitch_speed < 0:
			pitch_speed += 0.01

	global_rotate(transform.basis.x, 1 * pitch_speed * delta)

#yaw
	yaw_left = Input.get_action_strength("yaw left")
	yaw_right = Input.get_action_strength("yaw right")

	if f_speed < ideal_speed:
		max_yaw_left = f_speed / (ideal_speed * yaw_rate)
	else:
		max_yaw_left = ((f_speed / (ideal_speed * yaw_rate)) - ((f_speed - ideal_speed) / (ideal_speed * yaw_rate)) *2)
	if Input.is_action_pressed("yaw left"):
		if yaw_speed < max_yaw_left:
			yaw_speed += 0.0025 * yaw_left
		if yaw_speed > max_yaw_right:
			yaw_speed -= 0.0001
	else:
		if yaw_speed > 0:
			yaw_speed -= 0.01

#yaw gets to max yaw right faster than it gets to max yaw left, must fix

	if f_speed < ideal_speed:
		max_yaw_right = f_speed / (ideal_speed * (yaw_rate * -1))
	else:
		max_yaw_right = ((f_speed / (ideal_speed * (yaw_rate * -1))) + ((f_speed - ideal_speed) / (ideal_speed * yaw_rate)) * 2)
	if Input.is_action_pressed("yaw right"):
		if yaw_speed > max_yaw_right:
			yaw_speed -= 0.0025 * yaw_right
		if yaw_speed < max_yaw_right:
			yaw_speed += 0.0001
	else:
		if yaw_speed < 0:
			yaw_speed += 0.01

	if Input.is_action_pressed("speed 150"):
		if f_speed < ideal_speed:
			f_speed += 0.5
		if f_speed > ideal_speed:
			f_speed -= 0.5
		

	global_rotate(transform.basis.z, -1 * yaw_speed * delta)

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

	combined_speed = top_speed - ((speed_p + speed_y)*10)

#new throttle code
	throttle_add = Input.get_action_raw_strength("throttle") * 0.35
	throttle_sub = Input.get_action_raw_strength("brakes") * 0.35

	if throttle < 100:
		throttle += throttle_add
	if throttle > 100:
		throttle = 100
	if throttle > 0:
		throttle -= throttle_sub
	if throttle < 0:
		throttle = 0

	f_speed += ((throttle/100) - 0.05)
	f_speed -= (f_speed / 1100)



	# Add the gravity.
#	if not is_on_floor():
#		if velocity.y < 56:
#			velocity.y -= gravity * delta

#lift
	if f_speed < 70:
		velocity.y = (-70 + f_speed)


	if Input.is_action_pressed("throttle"):
		if f_speed < 15:
			f_speed += 0.1
	else:
		if f_speed > 0:
			f_speed -= 0.01

	var motion = (movementnode.global_basis * Vector3(0, 0, -1)).normalized()
	motion *= f_speed * delta

#elevator angle
	
	$"B-wing/Left_Elevator".rotation_degrees.x = ((pitch_down * 20 ) + ((pitch_up * -1) * 20))
	$"B-wing/Right_Elevator".rotation_degrees.x = (((pitch_down * -1) * 20 ) + (pitch_up * 20))

#camera inertia
	$Head/Camera3D.position.y = (pitch_speed * -0.05) #* ((f_speed - 500) / 250)
	$Head/Camera3D.position.x = ((yaw_speed * 0.1) + (roll_speed * 0.025))
	$Head/Camera3D.rotation.z = (roll_speed * -0.075)
	print ($Head/Camera3D.position.y)
	#print ($Head/Camera3D.position.x)
	#print ($Head/Camera3D.rotation.z)


	move_and_collide(motion)

	move_and_slide()



#end physics process, keep spaces

	if radar_counter > warning_number:
		$HUD/Detected.show()
		$HUD/WarningTimer.start()

	if radar_counter < warning_number:
		warning_hide()

	if f_speed > 1:
		z_volume = 0.02 + (0.001 * throttle)
	else:
		z_volume = 0
	$AudioStreamPlayer.volume_linear = z_volume

	$Head/Camera3D/ShakerComponent3D.intensity = 0.001 * (f_speed / 100)

#capture mouse etc

# true_speed_calc
	gp1 = global_position
	true_speed = (gp2.distance_to(gp1))
	gp2 = gp1
	#print ("true speed " + (str(true_speed * 134).pad_decimals(0)))

#calculate collision
	if (true_speed * 134) < (f_speed):
		print ("CRASH!")
		$"HUD/CRASH!".show()
	else:
		$"HUD/CRASH!".hide()

func update_speed():
	$"B-wing/Cockpit/HUD/Label3D".text = str(f_speed * 2.236).pad_decimals(0)
	$"B-wing/Cockpit/HUD/Label3D2".text = str(position.y * 3.281).pad_decimals(0)
	$"B-wing/Cockpit/HUD/Label3D3".text = str(throttle).pad_decimals(0) + ("%")
#	$HUD/Pitch.text = ("Pitch ") + str(($"Z-Wing2".rotation_degrees.x - 90) * -1).pad_decimals(0)
#	$HUD/Roll.text = ("Roll ") + str($"Z-Wing2".rotation_degrees.z).pad_decimals(0)

func warning_hide():
	$HUD/Detected.hide()

func sam_hit_z(_body_entered):
	get_parent().sam_hit()
	print ("sam hit z")

func warning_start():
		$AudioStreamPlayer2.playing = true
		#$AudioStreamPlayer2.autoplay = true
