extends Node

# constants

# variables

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	print("state machine running")

func get_state():
	pass