extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func resume():
	print ("test post")
	$".".hide()
	get_parent().get_tree().paused = false


func main_menu():
	#get_parent().get_tree().paused = true
	#^ doesn't work, need to fix, menu process currently set to always
	get_parent().get_parent().show()
	get_parent().queue_free()
