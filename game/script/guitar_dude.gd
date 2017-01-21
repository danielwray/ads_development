extends AnimatedSprite

# constants

# system variables
var tempElapsed = 0
var guitar_dude_start_position = set_start_position()
var guitar_dude_current_positon = get_pos()
var guitar_dude_z_depth
var guitar_dude_speed = 3
var player_is_attacking
var player_is_moving
var player_is_dead
# player variables
var guitar_dude_name
var guitar_dude_health
var guitar_dude_stamina
var guitar_dude_level
var guitar_dude_item_list

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	set_process_unhandled_input(true)
	# set player to start in center of screen
	set_pos(guitar_dude_start_position)

func _process(delta):
	# graphics refresh rate
	pass

func _fixed_process(delta):
	# physics refresh rate
	tempElapsed += delta
	set_pos(guitar_dude_current_positon)

func set_start_position():
	var guitar_dude_x = init.get_game_window_dimension()[0] / 4
	var guitar_dude_y = init.get_game_window_dimension()[1] / 2
	return Vector2(guitar_dude_x, guitar_dude_y)

func construct_player(name, health, stamina, level, item_list):
	guitar_dude_health= name
	guitar_dude_health = health
	guitar_dude_stamina = stamina
	guitar_dude_level = level
	guitar_dude_item_list = item_list

func _input(event):
	# input listener

	if Input.is_action_pressed("player_one_punch"):
		player_is_attacking = true
		player_is_moving = false
		cycle_animation("punch")
	elif Input.is_action_pressed("player_one_special"):
		player_is_attacking = true
		player_is_moving = false
		cycle_animation("special")
	elif Input.is_action_pressed("player_one_jump"):
		# not implemented yet
		pass
	elif Input.is_action_pressed("player_one_up"):
		guitar_dude_current_positon.y -= guitar_dude_speed
		player_is_moving = true
	elif Input.is_action_pressed("player_one_down"):
		player_is_moving = true
		guitar_dude_current_positon.y += guitar_dude_speed
	elif Input.is_action_pressed("player_one_left"):
		player_is_moving = true
		guitar_dude_current_positon.x -= guitar_dude_speed
		set_flip_h(true)
	elif Input.is_action_pressed("player_one_right"):
		player_is_moving = true
		guitar_dude_current_positon.x += guitar_dude_speed
		set_flip_h(false)
	elif player_is_moving:
		cycle_animation("walk")
	elif player_is_dead:
		set_animation("dead")
		get_node("samples").play("guitar_dude_dead", true)
	else:
		cycle_animation("idle")
		
func cycle_animation(animation):
	# play character animation cycles in a loop
	set_animation(animation)
	if(tempElapsed > 0.2):
		if(get_frame() == get_sprite_frames().get_frame_count(animation) - 1):
			set_frame(0)
			tempElapsed = 0
		else:
			set_frame(get_frame() + 1)
