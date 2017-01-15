extends VBoxContainer

func _ready():
	set_process(true)

func _on_start_pressed():
	# load init scene
	get_node("/root/init").set_scene("res://scene/level/level_001/level_001.tscn")

func _on_highscore_pressed():
	# load init scene
	print("A high score board")

func _on_exit_pressed():
	# exit game upon exit pressed
	get_tree().quit()
	