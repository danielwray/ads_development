extends Container

# variables
var difficulty

func _ready():
	# load difficulty drop down object and add values
	difficulty = get_node("difficulty_drop_down")
	difficulty.add_item("Too easy", 0)
	difficulty.add_item("Easy", 1)
	difficulty.add_item("Normal", 2)
	difficulty.add_item("Hard", 3)
	difficulty.add_item("Insane", 4)

# on_button_save get all values and write to global vars
# difficulty.get_selected()

func _on_save_pressed():
	init.set_difficulty(difficulty.get_selected())
	#get_node("../root/init").setScene(menu)