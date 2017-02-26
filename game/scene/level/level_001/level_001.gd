extends Node

# constants

# variables
# state machine resources
onready var state_machine = preload("res://script/state_machine.gd")
var state_machine_object
# difficulty
var enemy_min_count = 0
var enemy_max_count = 1
# timers
var spawn_timer = 0
# resources

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	state_machine_object = state_machine.new()
	load_characters()
	load_world()
	

func _fixed_process(delta):
	print(state_machine_object.get_state())

func load_characters():
	var player = ResourceLoader.load("res://scene/character/player/guitar_dude.tscn")
	add_child(player.instance())
	var enemies = ResourceLoader.load("res://scene/character/enemy/generic_metal_guy.tscn")
	add_child(enemies.instance())

func load_world():
	pass