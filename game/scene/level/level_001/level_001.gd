extends Node

# constants

# variables
# state machine resources
# difficulty
var difficulty = 4
var enemy_min_count = 2 * difficulty
var enemy_max_count = 5 * difficulty
# timers
var spawn_timer = 0
# resources
var camera
var player
var enemies

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	load_characters()
	load_world()
	

func _fixed_process(delta):
	pass

func load_characters():
	var player = ResourceLoader.load("res://scene/character/player/guitar_dude.tscn")
	add_child(player.instance())

	var enemies = ResourceLoader.load("res://scene/character/enemy/generic_metal_guy.tscn")
	for enemy in range(enemy_min_count, enemy_max_count):
		enemy = enemies.instance()
		enemy.set_pos(Vector2(rand_range(600, 10000), rand_range(300, 500)))
		add_child(enemy)

func load_world():
	pass