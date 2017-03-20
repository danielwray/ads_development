extends Node

# global game constants
const scene_files = {
	"characters": "res://tileset/character/character_tileset.tscn",
	"guitar_dude": "res://scene/character/player/guitar_dude.tscn",
	"generic_metal_guy": "res://scene/character/enemy/generic_metal_guy.tscn",
	"main_menu": "res://scene/menu/menu.tscn",
	"high_score": "res://scene/high_score/high_score.tscn",
	"credit": "res://scene/credit/credit.tscn",
	"setting": "res://scene/menu/setting_menu.tscn",
	"level_001": "res://scene/level/level_001/level_001.tscn"
}

# global game variables
# window
var screen_dimension = Vector2()
# configuration
var game_status = {}
var game_config = {}
var difficulty_level
# game status
var current_scene = null
var state_machine
var high_score = []
# game defaults
var default_player = "guitar_dude"
var enemy_character_list = ["generic_metal_guy"]

func _ready():
	# on load set current scene to last scene available
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1 )
	# set global values
	# enable fixed process to true
	set_fixed_process(true)
	randomize()

# loops

func _fixed_process(delta):
	# put looping global functions here
	# if escape is pressed set scene to main_menu
	if Input.is_action_pressed("menu"):
		set_scene(scene_files.main_menu)

# set functions

func set_scene(scene):
	# free current scene
	current_scene.queue_free()
	current_scene.remove_and_skip()
	# load the new scene passed in via the scene parameter
	var new_scene = ResourceLoader.load(scene)
	# update current_scene variable
	current_scene = new_scene.instance()
	# add scene to root
	get_tree().get_root().add_child(current_scene)

func set_player_high_score(score):
	high_score.append(int(score))

func set_difficulty(level):
	difficulty_level = level

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

func get_difficulty():
	var difficulty_level_override
	if difficulty_level == 0:
		difficulty_level_override = {
		"speed": 0.5, 
		"health": 75, 
		"damage": 0.5, 
		"spawn_rate": 100, 
		"attack_distance": 500,
		"enemy_number": 5
		}
	elif difficulty_level == 1:
		difficulty_level_override = {
		"speed": 1, 
		"health": 100, 
		"damage": 1, 
		"spawn_rate": 75, 
		"attack_distance": 800,
		"enemy_number": 15
		}
	elif difficulty_level == 2:
		difficulty_level_override = {
		"speed": 1.25, 
		"health": 100, 
		"damage": 1.25, 
		"spawn_rate": 65, 
		"attack_distance": 900,
		"enemy_number": 20
		}
	elif difficulty_level == 3:
		difficulty_level_override = {
		"speed": 1.75, 
		"health": 125, 
		"damage": 2, 
		"spawn_rate": 50, 
		"attack_distance": 1200,
		"enemy_number": 30
		}
	elif difficulty_level == 4:
		difficulty_level_override = {
		"speed": 2, 
		"health": 150, 
		"damage": 4, 
		"spawn_rate": 25, 
		"attack_distance": 1500,
		"enemy_number": 50
		}
	else:
		difficulty_level_override = {
		"speed": 1.25, 
		"health": 100, 
		"damage": 1.25, 
		"spawn_rate": 65, 
		"attack_distance": 900,
		"enemy_number": 20
		}
	return difficulty_level_override

func get_player_high_score():
	return high_score

# utility functions

func read_json(file_path):
	var file_object = File.new()
	file_object.open(file_path, file_object.READ)
	var content = {}
	content.parse_json(file_object.get_line())
	file_object.close()
	print(content)
	return content

func get_screen_size():
	return OS.get_window_size()