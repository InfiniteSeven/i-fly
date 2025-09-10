extends Node
@onready var menu_node = preload("res://menu/menu.tscn")
@onready var world = preload("res://map/main.tscn")
@onready var main_menu = $MainMenu
@onready var death_screen = $DeathScreen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu = menu_node.instantiate()
	#add_child(menu)
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func play():
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
