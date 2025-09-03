extends CharacterBody3D

## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
@export var input_left : String = "ui_left"
@export var input_right : String = "ui_right"
@export var input_forward : String = "ui_up"
@export var input_back : String = "ui_down"
@export var input_sprint : String = "sprint"
@export var input_freefly : String = "freefly"

@export_group ("look actions")
@export var look_left : String = "look left"
@export var look_right : String = "look right"
@export var look_up : String = "look up"
@export var look_down : String = "look down"

var mouse_captured : bool = false
var look_rotation : Vector3
var move_speed : float = 0.0
var freeflying : bool = false

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

@export var rotate_numbers = 0

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)

	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	print (rotation.z)
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		if Input.is_action_pressed("rotate left"):
			rotate_numbers = 0.025
		elif Input.is_action_pressed("rotate right"):
			rotate_numbers = -0.025
		else:
			rotate_numbers = 0
		rotate_z(rotate_numbers)
		return

	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

# Apply desired movement to velocity
	var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_dir:
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	# Use velocity to actually move
	move_and_slide()

	if Input.is_action_pressed("look left"):
		look_rotation.y -= -35 * look_speed
	if Input.is_action_pressed("look right"):
		look_rotation.y -= 35 * look_speed
	if Input.is_action_pressed("look up"):
		look_rotation.x -= -15 * look_speed
	if Input.is_action_pressed("look down"):
		look_rotation.x -= 15 * look_speed
	if Input.is_action_pressed("rotate left"):
		rotate_numbers += 0.1
	if Input.is_action_pressed("rotate right"):
		rotate_numbers -= 0.1
	transform.basis = Basis()
	head.transform.basis = Basis()
	rotate_x(look_rotation.x)
	rotate_y(look_rotation.y)
#	rotate_z(rotate_numbers)


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	head.transform.basis = Basis()
	rotate_x(look_rotation.x)
	rotate_y(look_rotation.y)
	#rotate_z(rotate_numbers)

#func _input(event: InputEvent) -> void:

func enable_freefly():
	collider.disabled = false
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
