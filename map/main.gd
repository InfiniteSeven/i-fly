extends Node3D

var z_position : Vector3
@onready var missile_node = preload("res://missile/missile.tscn")

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		pause_menu()

func _physics_process(_delta) -> void:
	z_position = $"Z-Wing".global_position

func sam_hit():
	get_parent().show()
	get_parent().death_screen.show()
	$".".queue_free()

func pause_menu():
	$PauseMenu.show()
	get_tree().paused = true
