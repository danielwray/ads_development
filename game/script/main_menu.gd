extends VBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_start_pressed():
	# initiate game global variables
	# load scene file (read current_level.json)
	# switch scene and handover to main.gd script
	print("Starting game")

func _on_highscore_pressed():
	# view highscore
	# load highscore scene
	# read highscore file
	print("A high score board")

func _on_exit_pressed():
	# exit game upon exit pressed
	get_tree().quit()
	