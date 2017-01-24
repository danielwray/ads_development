extends Node

# constants

# variables
var character_player_list = []
var character_enemy_list = []
var characters

func _ready():
	pass

func state_machine():
	for character_node in characters:
		if get_character_state(character_node) == "dead":
			var enemy_list_index = character_enemy_list.find(character_node)
			character_enemy_list.remove(enemy_list_index)
			character_node.queue_free()
			character_node.remove_and_skip()
		if get_character_state(character_node) == "idle":
			pass
		elif get_character_state(character_node) == "moving":
			pass
		elif get_character_state(character_node) == "attacking":
			pass
		elif get_character_state(character_node) == "special":
			pass

func create_character_instance():
	pass

func get_character_instance_stats():
	pass

func get_character_state(character):
	var chnode = character.get_name()
	var test1 = str("../", chnode)
	var test = get_node(test1)

func set_character_state(state):
	return state

func update_character_list():
	characters = get_tree().get_nodes_in_group("characters")
	for character_type in characters:
		if is_in_group("enemy"):
			character_enemy_list.append(character_type)
		else:
			character_player_list.append(character_type)