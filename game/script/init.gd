extends Node

# global game constants
const scene_files = {
	"guitar_dude": "res://scene/character/player/guitar_dude.tscn",
	"generic_metal_guy": "res://scene/character/enemy/generic_metal_guy.tscn",
	"main_menu": "res://scene/menu/menu.tscn",
	"high_score": "res://scene/high_score/high_score.tscn",
	"credit": "res://scene/credit/credit.tscn",
	"level_001": "res://scene/level/level_001/level_001.tscn"
}

# global game variables
var screen_dimension = Vector2()
var game_status = {}
var game_config = {}
var current_scene = null
var difficulty_level = 3
var default_player = "guitar_dude"
var enemy_character_list = ["generic_metal_guy"]

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
		set_scene(scene_files.main_menu)

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

func get_game_window_dimension():
	return OS.get_window_size()

func get_game_status():
	return game_status

func get_game_config():
	return game_config

func get_scene_files(scene):
	if scene in scene_files.keys():
		return scene_files[scene]
