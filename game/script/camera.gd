extends Node

# variables
var camera
var player_health
var player_special

func _ready():
	set_process(true)
	player_health = get_node("main_canvas/player_health_bar")
	player_special = get_node("main_canvas/player_special_bar")

func _process(delta):
	#print(get_tree().call_group(0, "player", "get_health"))
	var get_player_object = get_tree().get_nodes_in_group("player")[0]
	# set health value
	player_health.set_value(get_player_object.get_health())
	# set special value
	player_special.set_value(get_player_object.get_special())
	# setup camera to follow player
	camera = get_node("main_camera")
	var player_position = get_player_object.get_pos()
	var new_camera_position = player_position
	camera.set_global_pos(new_camera_position)
	camera.set_zoom(Vector2(1, 1))


