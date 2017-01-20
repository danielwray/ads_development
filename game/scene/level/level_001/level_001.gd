extends Node

# constants

# variables
var enemy_min_count = round(init.difficulty_level / 2)
var enemy_max_count = round(init.difficulty_level * 2)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	load_characters()
	load_world()

func load_characters():
	# find character scene paths
	var player_scene = init.get_scene_files(init.default_player)
	# randomize this at some point to pick from the available list
	var enemy_scene = init.get_scene_files(init.enemy_character_list[0])
	# load resources
	var player_object = ResourceLoader.load(player_scene)
	var enemy_object = ResourceLoader.load(enemy_scene)
	# add instances
	add_child(player_object.instance())
	# this needs refactoring
	# set up to spawn enemies in boundary of defined areas (shapes)
	# create list of enemies upon spawning to reference at a later point
	for enemy in range(enemy_min_count, enemy_max_count):
		var enemy_node = enemy_object.instance()
		enemy_node.set_pos(Vector2(rand_range(900, 1300), rand_range(100, 400)))
		var enemy_instance = get_node(".").add_child(enemy_node)
		
		

func load_world():
	# find world scene paths
	# load resources
	# add instances
	pass