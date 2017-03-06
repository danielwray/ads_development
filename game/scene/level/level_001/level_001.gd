extends Node

# constants

# variables
# state machine resources
# difficulty
var difficulty = 4
var enemy_min_count = 8 * difficulty
var enemy_max_count = 12 * difficulty
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
	if spawn_timer > 100:
		spawn_enemy()
		spawn_timer = 0
	spawn_timer += 0.25

func load_characters():
	var player = ResourceLoader.load("res://scene/character/player/guitar_dude.tscn")
	add_child(player.instance())

func spawn_enemy():
	var enemies = ResourceLoader.load("res://scene/character/enemy/generic_metal_guy.tscn")
	var player_object = get_tree().get_nodes_in_group("player")[0]
	var player_position = player_object.get_pos().x
	player_position = player_position + rand_range(800, 1000)
	var enemy = enemies.instance()
	enemy.set_pos(Vector2(player_position, rand_range(300, 500)))
	add_child(enemy)

func load_world():
	pass