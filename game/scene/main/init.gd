extends Node

# global game constants
var scene_files = {
	"menu": "res://scene/menu/menu.tscn",
	"high_score": "res://scene/high_score/high_score.tscn",
	"level_001": "res://scene/level/level_001/level_001.tscn"
}

var character_files = {
	"guitar_player": "res://scene/character/guitardude.tscn"
}

# global game variables
var game_status = {}
var game_config = {}

# local game init variables
var current_scene = null

func _ready():
	# on load set current scene to last scene available
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1 )
	# set global values
	# enable fixed process to true
	set_fixed_process(true)

# loops

func _fixed_process(delta):
	# put looping global functions here
	if Input.is_action_pressed("menu"):
		set_scene(scene_files.menu)

# set functions

func set_scene(scene):
	# free current scene
	current_scene.queue_free()
	# load the new scene passed in via the scene parameter
	var new_scene = ResourceLoader.load(scene)
	# update current_scene variable
	current_scene = new_scene.instance()
	# add scene to root
	get_tree().get_root().add_child(current_scene)

# get functions

func get_game_status():
	return game_status

func get_game_config():
	return game_config

func get_scene_files(scene):
	if scene in scene_files.keys():
		return scene_files[scene]
