extends Node
@onready var menu_node = preload("res://menu/menu.tscn")
@onready var world = preload("res://map/main.tscn")
@onready var main_menu = $MainMenu
@onready var death_screen = $DeathScreen
var mouse_captured : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu = menu_node.instantiate()
	#add_child(menu)
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func play():
	get_tree().paused = false
	$".".hide()
	main_menu.hide()
	var game_world = world.instantiate()
	add_child(game_world)
	print ("test")

func quit():
	get_tree().quit()

func death_to_main():
	death_screen.hide()
	main_menu.show()

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		release_mouse()

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
