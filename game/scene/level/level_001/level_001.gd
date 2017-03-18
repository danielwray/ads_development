extends Node

# constants
# variables
# state machine resources
# difficulty
var difficulty
var enemy_min_count
var enemy_max_count
# timers
var spawn_timer = 0
var spawn_timer_limit = 0
var spawn_limit = 100
var spawned = 0
# resources
var camera
var player
var enemies = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	difficulty = init.get_difficulty()
	enemy_min_count = difficulty * 5
	enemy_max_count = difficulty * 15
	enemies.append("res://scene/character/enemy/generic_metal_guy.tscn")
	enemies.append("res://scene/character/enemy/enemy.tscn")
	load_characters()
	load_world()

func _fixed_process(delta):
	spawn_timer_limit = rand_range(75, 200) - difficulty
	if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
		spawned += 1
		print(spawned)
		spawn_enemy()
		spawn_timer = 0
	spawn_timer += 0.25

func load_characters():
	var player = ResourceLoader.load("res://scene/character/player/guitar_dude.tscn")
	add_child(player.instance(), true)

func spawn_enemy():
	var player_object = get_tree().get_nodes_in_group("player")[0]
	var player_position = player_object.get_pos().x
	player_position = player_position + rand_range(800, 1200)
	var enemy = ResourceLoader.load(enemies[rand_range(0, enemies.size())])
	var enemy_instance = enemy.instance()
	enemy_instance.set_pos(Vector2(player_position, rand_range(300, 500)))
	add_child(enemy_instance,true)

func load_world():
	pass