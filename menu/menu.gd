extends Node
@onready var menu_node = preload("res://menu/menu.tscn")
@onready var world = preload("res://map/main.tscn")
@onready var main_menu = $CanvasLayer/MainMenu
@onready var death_screen = $CanvasLayer/DeathScreen
var mouse_captured : bool = false

@export var resolution_d : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu = menu_node.instantiate()
	#add_child(menu)
	pass # Replace with function body.

func play():
	get_tree().paused = false
	$".".hide()
	main_menu.hide()
	var game_world = world.instantiate()
	add_child(game_world)

func resolutions():
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/Settings.show()

func quit():
	get_tree().quit()

func death_to_main():
	death_screen.hide()
	main_menu.show()

func _input(_event: InputEvent) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	#	capture_mouse()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		release_mouse()

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


func change_resolution(call):
	DisplayServer.window_set_size(call)
	pass

func change_window_mode(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func back_to_main():
	$CanvasLayer/Settings.hide()
	$CanvasLayer/MainMenu.show()
