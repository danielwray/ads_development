extends AnimationPlayer

# global variables
var credit_animation
var timer = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	credit_animation = play("credit_animation")
	set_fixed_process(true)

func _fixed_process(delta):
	if not is_playing():
		timer += 1
		if timer >= 10:
			load_scene("main_menu")
	else:
		timer = 0

func load_scene(scene):
	var scene_file = init.get_scene_files(scene)
	init.set_scene(scene_file)