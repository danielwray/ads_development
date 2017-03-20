extends Node

# variables
var difficulty

func _ready():
	# load difficulty drop down object and add values
	difficulty = get_node("menu/difficulty_drop_down")
	difficulty.add_item("Too easy", 5)
	difficulty.add_item("Easy", 7.5)
	difficulty.add_item("Normal", 10)
	difficulty.add_item("Hard", 20)
	difficulty.add_item("Insane", 30)

func _on_difficulty_drop_down_item_selected( ID ):
	init.set_difficulty(ID)
