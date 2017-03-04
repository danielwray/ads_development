extends Node

# variables
var camera
var player_health
var player_health_progress_bar

func _ready():
	set_process(true)
	player_health_progress_bar = get_node("main_canvas/player_health_bar")

func _process(delta):
	#print(get_tree().call_group(0, "player", "get_health"))
	var get_player_object = get_tree().get_nodes_in_group("player")[0]
	camera = get_node("main_camera")
	var player_position = get_node("../guitar_dude").get_pos()
	var new_camera_position = player_position
	camera.set_global_pos(new_camera_position)
	camera.set_zoom(Vector2(1, 1))
	# set health value
	player_health_progress_bar.set_value(get_player_object.health)


