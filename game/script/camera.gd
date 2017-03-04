extends Node

# variables
var camera

func _ready():
	set_process(true)

func _process(delta):
	camera = get_node("main_camera")
	var player_position = get_node("../guitar_dude").get_pos()
	var new_camera_position = player_position
	camera.set_global_pos(new_camera_position)
	camera.set_zoom(Vector2(1, 1))


