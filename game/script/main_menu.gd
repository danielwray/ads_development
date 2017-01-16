extends VBoxContainer

func _ready():
	set_process(true)

func _on_start_pressed():
	# load init scene
	load_scene("level_001")

func _on_highscore_pressed():
	# load init scene
	load_scene("high_score")

func _on_exit_pressed():
	# exit game upon exit pressed
	get_tree().quit()

func load_scene(scene):
	var scene_file = init.get_scene_files(scene)
	init.set_scene(scene_file)