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
# audio variables
var intro_sound
var loop_1_sound
var loop_2_sound
var guitar_special_sound
var loop_is_playing

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	# append characters to scene
	enemies.append("res://scene/character/enemy/generic_metal_guy.tscn")
	enemies.append("res://scene/character/enemy/enemy.tscn")
	# set spawn limits
	spawn_timer_limit = difficulty.spawn_rate
	spawn_limit = difficulty.enemy_number
	# load functions
	load_characters()
	load_world()
	intro_sound = get_node("track_1_intro")
	loop_1_sound = get_node("track_1_loop_1")
	loop_2_sound = get_node("track_1_loop_2")
	guitar_special_sound = get_node("track_1_guitar_special")
	intro_sound.play(0)

func _fixed_process(delta):
	if not intro_sound.is_playing() and not loop_is_playing:
		loop_is_playing = true
		loop_1_sound.play(0)
	if not loop_1_sound.is_playing():
		loop_is_playing = false
	if not loop_1_sound.is_playing() and not loop_is_playing:
		loop_is_playing = true
		loop_2_sound.play(0)
	if level_status.end:
		print("level completed")
	elif level_status.stage_1:
		spawn_timer_limit = difficulty.spawn_rate
		spawned = 0
		if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
			spawned += 1
			spawn_enemy()
			spawn_timer = 0
		spawn_timer += 0.25
	elif level_status.stage_2:
		spawned = 0
		spawn_timer_limit = difficulty.spawn_rate
		if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
			spawned += 1
			spawn_enemy()
			spawn_timer = 0
		spawn_timer += 0.25
	elif level_status.stage_3:
		spawned = 0
		spawn_timer_limit = difficulty.spawn_rate
		if spawn_timer > spawn_timer_limit and spawned < spawn_limit:
			spawned += 1
			spawn_enemy()
			spawn_timer = 0
		spawn_timer += 0.25
	elif level_status.boss:
		spawn_enemy()
	elif level_status.start:
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
	# refactor this to spawn enemies before / after player and more randomly
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

func _on_stage_1_body_enter( body ):
	if body.is_in_group("player"):
		level_status.stage_1 = true

func _on_stage_2_body_enter( body ):
	if body.is_in_group("player"):
		level_status.stage_2 = true

func _on_stage_3_body_enter( body ):
	if body.is_in_group("player"):
		level_status.stage_3 = true

func _on_end_body_enter( body ):
	if body.is_in_group("player"):
		level_status.end = true

func _on_boss_body_enter( body ):
	if body.is_in_group("player"):
		level_status.boss = true