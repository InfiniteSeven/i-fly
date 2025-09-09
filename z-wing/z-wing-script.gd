extends CharacterBody3D

class_name z_wing

var mouse_captured : bool = false

@onready var radar_counter = 0


@export_group("Speeds")
const key_turn_speed = 0.05
const mouse_turn_speed = 0.002
@export var forward_speed = 0.0
@export var roll_speed = 0.0
@export var pitch_speed = 0.0
@export var yaw_speed = 0.0
@export var combined_speed = 0.0
@export var speed_r = 0.0
@export var speed_p = 0.0
@export var speed_y = 0.0
var gravity = 1

@export var z_volume : float

@onready var head = $Head
@onready var camera = $Camera3D

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
var throttle : float
var brakes


func _ready():
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

#pitch yaw
	if mouse_captured == true:
		if event is InputEventMouseMotion:
			#global_rotate(-event.relative.x, 0.02 * rotation_speed)
			camera.rotate_z(-event.relative.x * mouse_turn_speed)
			camera.rotate_x(-event.relative.y * mouse_turn_speed)

#			head.rotation.y = clamp(head.rotation.y, deg_to_rad(-85), (deg_to_rad(85)))
#			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-15), (deg_to_rad(60)))

func _process(float):
	pass

func _physics_process(delta: float) -> void:

#engine
	$MeshInstance3D/Engine.material.emission_energy_multiplier = (forward_speed * 0.01)
	$MeshInstance3D/Engine/Engine.light_energy = (forward_speed * 0.06)

#roll
	roll_left = Input.get_action_strength("roll left")
	roll_right = Input.get_action_strength("roll right")

	if forward_speed < 150:
		max_roll_left = (forward_speed / 50)
	else:
		max_roll_left = ((forward_speed / 50) - ((forward_speed - 150) / 50) * 2)
	if Input.is_action_pressed("roll left"):
		#print ("max roll left " + str(max_roll_left).pad_decimals(2))
		#print ("roll speed " + str(roll_speed).pad_decimals(2))
		if roll_speed < max_roll_left:
			roll_speed += 0.1 * roll_left
		if roll_speed > max_roll_left:
			roll_speed -= 0.01
	else:
		if roll_speed > 0:
			roll_speed -= 0.02

	if forward_speed < 150:
		max_roll_right = forward_speed / -50
	else:
		max_roll_right = ((forward_speed / -50) + ((forward_speed - 150) / 50) * 2)
	if Input.is_action_pressed("roll right"):
		#print ("max roll right " + str(max_roll_right).pad_decimals(2))
		#print ("roll speed " + str(roll_speed).pad_decimals(2))
		if roll_speed > max_roll_right:
			roll_speed -= 0.1 * roll_right
		if roll_speed < max_roll_right:
			roll_speed += 0.01
	else:
		if roll_speed < 0:
			roll_speed += 0.02

	global_rotate(transform.basis.y, 1 * roll_speed * delta)

#pitch
	pitch_up = Input.get_action_strength("pitch up")
	pitch_down = Input.get_action_strength("pitch down")

	if forward_speed < 150:
		max_pitch_up = forward_speed / 100
	else:
		max_pitch_up = ((forward_speed / 100) - ((forward_speed - 150) / 150) * 2)
	if Input.is_action_pressed("pitch up"):
		#print ("max pitch up " + str(max_pitch_up).pad_decimals(2))
		#print ("pitch speed " + str(pitch_speed).pad_decimals(2))
		if pitch_speed < max_pitch_up:
			pitch_speed += 0.05 * pitch_up
		if pitch_speed > max_pitch_up:
			pitch_speed -= 0.01
	else:
		if pitch_speed > 0:
			pitch_speed -= 0.01

	if forward_speed < 150:
		max_pitch_down = forward_speed / -100
	else:
		max_pitch_down = ((forward_speed / -100) + ((forward_speed - 150) / 150) * 2)
	if Input.is_action_pressed("pitch down"):
		#print ("max pitch down " + str(max_pitch_down).pad_decimals(2))
		#print ("pitch speed " + str(pitch_speed).pad_decimals(2))
		if pitch_speed > max_pitch_down:
			pitch_speed -= 0.05 * pitch_down
		if pitch_speed < max_pitch_down:
			pitch_speed += 0.01
	else:
		if pitch_speed < 0:
			pitch_speed += 0.01

	global_rotate(transform.basis.x, 1 * pitch_speed * delta)

#yaw
	yaw_left = Input.get_action_strength("yaw left")
	yaw_right = Input.get_action_strength("yaw right")

	if forward_speed < 150:
		max_yaw_left = forward_speed / 300
	else:
		max_yaw_left = ((forward_speed / 300) - ((forward_speed - 150) / 300) *2)
	if Input.is_action_pressed("yaw left"):
		#print ("max yaw left " + str(max_yaw_left).pad_decimals(2))
		#print ("yaw speed " + str(yaw_speed).pad_decimals(2))
		if yaw_speed < max_yaw_left:
			yaw_speed += 0.02 * yaw_left
		if yaw_speed > max_yaw_right:
			yaw_speed -= 0.01
	else:
		if yaw_speed > 0:
			yaw_speed -= 0.01


	if forward_speed < 150:
		max_yaw_right = forward_speed / -300
	else:
		max_yaw_right = ((forward_speed / -300) + ((forward_speed - 150) / 300) * 2)
	if Input.is_action_pressed("yaw right"):
		#print ("max yaw right " + str(max_yaw_right).pad_decimals(2))
		#print ("yaw speed " + str(yaw_speed).pad_decimals(2))
		if yaw_speed > max_yaw_right:
			yaw_speed -= 0.02 * yaw_right
		if yaw_speed < max_yaw_right:
			yaw_speed += 0.01
	else:
		if yaw_speed < 0:
			yaw_speed += 0.01

	if Input.is_action_pressed("speed 150"):
		if forward_speed < 150:
			forward_speed += 0.5
		if forward_speed > 150:
			forward_speed -= 0.5
		

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

	combined_speed = 250 - ((speed_p + speed_y)*10)


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

#brakes
	brakes = Input.get_action_strength("brakes")

	if Input.is_action_pressed("brakes"):
		if forward_speed > 0 :
			forward_speed -= 1 * brakes

	# Add the gravity.
#	if not is_on_floor():
#		if velocity.y < 56:
#			velocity.y -= gravity * delta

#lift
	if forward_speed > 0 and forward_speed < 5:
		velocity.y = -10
	if forward_speed > 5 and forward_speed < 10:
		velocity.y = -8
	if forward_speed > 10 and forward_speed < 15:
		velocity.y = -6
	if forward_speed > 15 and forward_speed < 20:
		velocity.y = -4
	if forward_speed > 20 and forward_speed < 25:
		velocity.y = -2
	if forward_speed > 25:
		velocity.y = 0

	if Input.is_action_pressed("throttle"):
		if forward_speed < 15:
			forward_speed += 0.1
	else:
		if forward_speed > 0:
			forward_speed -= 0.01

	var motion = (head.global_basis * Vector3(0, 0, -1)).normalized()
	motion *= forward_speed * delta

	move_and_collide(motion)

	move_and_slide()

	if radar_counter > 600:
		$HUD/Detected.show()
		$HUD/WarningTimer.start()

	if radar_counter < 600:
		warning_hide()

	if forward_speed > 1:
		z_volume = 0.001 * forward_speed
	else:
		z_volume = 0
	$AudioStreamPlayer.volume_linear = z_volume


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func update_speed():
	$HUD/Speed.text = ("Speed ") + str(forward_speed).pad_decimals(0)
	$HUD/Altitude.text = ("Altitude ") + str(position.y).pad_decimals(0)
#	$HUD/Pitch.text = ("Pitch ") + str(($"Z-Wing2".rotation_degrees.x - 90) * -1).pad_decimals(0)
#	$HUD/Roll.text = ("Roll ") + str($"Z-Wing2".rotation_degrees.z).pad_decimals(0)

func warning_hide():
	$HUD/Detected.hide()

func sam_hit_z(body_entered):
	get_parent().sam_hit()
	print ("sam hit z")

func warning_start():
		$AudioStreamPlayer2.playing = true
		#$AudioStreamPlayer2.autoplay = true
