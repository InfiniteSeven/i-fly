extends Node

var mouse_captured : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func resume():
	print ("test post")
	$".".hide()
	get_parent().get_tree().paused = false


func main_menu():
	#get_parent().get_tree().paused = true
	#^ doesn't work, need to fix, menu process currently set to always
	get_parent().get_parent().show()
	get_parent().get_parent().main_menu.show()
	get_parent().queue_free()

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
