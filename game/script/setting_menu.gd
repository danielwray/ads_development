extends Node

# variables
var difficulty

func _ready():
	# load difficulty drop down object and add values
	difficulty = get_node("menu/difficulty_drop_down")
	difficulty.add_item("Normal", 0.75)
	difficulty.add_item("Too easy", 0.25)
	difficulty.add_item("Easy", 0.5)
	difficulty.add_item("Hard", 2)
	difficulty.add_item("Insane", 5)

func _on_difficulty_drop_down_item_selected( ID ):
	init.set_difficulty(ID)
