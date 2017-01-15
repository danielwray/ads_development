extends Node

# current active scene
var current_scene = null

# global game variables
# read from .status.json
var game_status = null
var player_one = {}
var player_two = {}
# read from config.json
var game_config = null

func _ready():
	# on load set current scene to last scene available
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1 )
	# set global values
	# example Globals.set("max_enemy_health", 100)
	# enable fixed process to true
	set_fixed_process(true)

func _fixed_process(delta):
	# put looping global functions here
	if Input.is_action_pressed("menu"):
		set_scene("res://scene/menu/menu.tscn")

func set_scene(scene):
	# free current scene
	current_scene.queue_free()
	# load the new scene passed in via the scene parameter
	var new_scene = ResourceLoader.load(scene)
	# update current_scene variable
	current_scene = new_scene.instance()
	# add scene to root
	get_tree().get_root().add_child(current_scene)
	
func get_game_status():
	return game_status

func get_game_config():
	return game_config
	
func get_player_one_name():
	if get_game_status():
		return player_one

func get_player_two_name():
	if get_game_status():
		return player_two