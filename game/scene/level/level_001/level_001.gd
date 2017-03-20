extends Node

# constants
# variables
# state machine resources
# difficulty
# get difficulty values

onready var difficulty = init.get_difficulty()
var enemy_min_count
var enemy_max_count
# timers
var spawn_timer = 0
var spawn_timer_limit
var spawn_limit
var spawned = 0
# resources
var camera
var player
var enemies = []
# level areas
var level_status = {
	"start": false, 
	"stage_1": false, 
	"stage_2": false, 
	"stage_3": false, 
	"boss": false, 
	"end": false
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	# append characters to scene
	enemies.append("res://scene/character/enemy/generic_metal_guy.tscn")
	enemies.append("res://scene/character/enemy/enemy.tscn")
	# set spawn limits
	spawn_timer_limit = difficulty.spawn_rate
	spawn_limit = difficulty.enemy_number / 2
	# load functions
	load_characters()
	load_world()

func _fixed_process(delta):
	if level_status.end:
		print("level completed")
	elif level_status.stage_1:
		print("STAGE: 1" + " SPAWN LIMIT: " + str(spawn_limit) + " TIMER LIMIT: " + str(spawn_timer_limit) + " SPAWNED: " + str(spawned) + " TIME: " + str(spawn_timer))
		spawn_timer_limit = difficulty.spawn_rate
		if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
			spawned += 1
			spawn_enemy()
			spawn_timer = 0
		spawn_timer += 0.25
	elif level_status.stage_2:
		print("STAGE: 2" + " SPAWN LIMIT: " + str(spawn_limit) + " TIMER LIMIT: " + str(spawn_timer_limit) + " SPAWNED: " + str(spawned) + " TIME: " + str(spawn_timer))
	elif level_status.stage_3:
		print("STAGE: 3" + " SPAWN LIMIT: " + str(spawn_limit) + " TIMER LIMIT: " + str(spawn_timer_limit) + " SPAWNED: " + str(spawned) + " TIME: " + str(spawn_timer))
	elif level_status.boss:
		print("STAGE: BOSS" + " SPAWN LIMIT: " + str(spawn_limit) + " TIMER LIMIT: " + str(spawn_timer_limit) + " SPAWNED: " + str(spawned) + " TIME: " + str(spawn_timer))
	elif level_status.start:
		print("STAGE: START" + "SPAWN LIMIT: " + str(spawn_limit) + " TIMER LIMIT: " + str(spawn_timer_limit) + " SPAWNED: " + str(spawned) + " TIME: " + str(spawn_timer))
		spawn_timer_limit = difficulty.spawn_rate
		if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
			spawned += 1
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

func _on_start_body_enter( body ):
	if body.is_in_group("player"):
		level_status.start = true

func _on_end_body_enter( body ):
	if body.is_in_group("player"):
		level_status.end = true

func _on_boss_body_enter( body ):
	if body.is_in_group("player"):
		level_status.boss = true

func _on_stage_1_body_enter( body ):
	if body.is_in_group("player"):
		level_status.stage_1 = true
