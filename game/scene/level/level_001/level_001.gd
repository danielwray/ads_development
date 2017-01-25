extends Node

# constants

# variables
# state machine resources
var state_machine_source
var state_machine
# difficulty
var enemy_min_count = 0
var enemy_max_count = 1
# timers
var spawn_timer = 0
# resources
var health_ui

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	load_characters()
	load_world()

func _fixed_process(delta):
	var test = get_node("state_machine")
	test.update_character_list()
	test.state_machine()
	health_ui = get_node("health/health_value")
	health_ui.set_text(str(get_node("guitar_dude").get_health()))
	

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
	for enemy in range(0, rand_range(2, 6)):
		var enemy_node = enemy_object.instance()
		enemy_node.set_pos(Vector2(rand_range(700, 1500), rand_range(200, 600)))
		var enemy_instance = get_node(".").add_child(enemy_node)

func load_world():
	# find world scene paths
	# load resources
	# add instances
	pass