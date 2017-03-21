extends Node

# variables
var difficulty

func _ready():
	# load difficulty drop down object and add values
	difficulty = get_node("menu/difficulty_drop_down")
	difficulty.set_text("Difficulty")
	difficulty.add_separator()
	difficulty.add_item("(Too easy) I'm a finger up the bum kind of guy...", 5)
	difficulty.add_item("(Easy) I have pilonidal sinus, therefore I would like to take it easy...", 7.5)
	difficulty.add_item("(Normal) I prefer being in a pit with men...", 10)
	difficulty.add_item("(Hard) Manowar, and men in leather get me...", 20)
	difficulty.add_item("(Insane) I prefer Enya...", 30)

func _on_difficulty_drop_down_item_selected( ID ):
	print(ID)
	init.set_difficulty(ID)
