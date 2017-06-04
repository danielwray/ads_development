extends VBoxContainer

var music_loop

func _ready():
	set_process(true)
	set_process_unhandled_input(true)
	music_loop = get_node("background_music_loop")
	music_loop.play()
	music_loop.set_volume(0.5)

func _on_start_pressed():
	# load init scene
	load_scene("level_001")
	music_loop.stop()

func _on_highscore_pressed():
	# load init scene
	load_scene("high_score")
	music_loop.stop()

func _on_credit_pressed():
	# load credit scene
	load_scene("credit")
	music_loop.stop()

func _on_setting_pressed():
	# load setting menu scene
	load_scene("setting")
	music_loop.stop()

func _on_exit_pressed():
	# exit game upon exit pressed
	music_loop.stop()
	get_tree().quit()

func load_scene(scene):
	var scene_file = init.get_scene_files(scene)
	init.set_scene(scene_file)
	music_loop.stop()