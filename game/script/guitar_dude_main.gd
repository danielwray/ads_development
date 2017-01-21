extends KinematicBody2D

# constants
# movement
const WALK_SPEED = 0.025
# variables
# movement
var velocity = Vector2()
var slide_count = 0
var slide_limit = 2
# character state
var is_attacking = false
var is_hit = false
var is_moving = false
var is_dead = false
# character status
# export to editor (see value sliders on the right)
export var health = 100
export var stamina = 100
# resources
var sprite
var audio
var collision

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	# set node variables
	sprite = get_node("guitar_dude_sprite")
	audio = get_node("guitar_dude_audio")
	collision = get_node("guitar_dude_collision")
	# set start position
	var start_x = init.get_game_window_dimension()[0] / 4
	var start_y = init.get_game_window_dimension()[1] / 2
	set_pos(Vector2(start_x, start_y))

func _fixed_process(delta):
	#
	# MOVEMENT
	#
	# movement logic
	# if input is true increase velocity and check for collision
	# get collision normal and pass to movement (built in function)
	# increment slide_count to smooth stop / start action of movement
	# if slide_count is greater than limit then set velocity (x,y) to 0
	if (Input.is_action_pressed("player_one_left") and not is_attacking || is_hit):
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		sprite.set_flip_h(true)
		velocity.x -= WALK_SPEED
	if (Input.is_action_pressed("player_one_right") and not is_attacking || is_hit):
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		sprite.set_flip_h(false)
		velocity.x += WALK_SPEED
	if (Input.is_action_pressed("player_one_up") and not is_attacking || is_hit):
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		velocity.y -= WALK_SPEED
	if (Input.is_action_pressed("player_one_down") and not is_attacking || is_hit):
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		velocity.y += WALK_SPEED
	
	# check slide_count, set velocity (x,y) to 0, and if not attacking set animation to idle
	slide_count += 1
	if (is_moving and slide_count > slide_limit):
		velocity = Vector2(0,0)
		if not (is_attacking):
			is_moving = false
			play_sprite_animation("idle")
	# set motion to velocity (x, y) times by the delta, and call builtin move function
	# var motion = velocity * derivative_time (gradual increase in movement speed (smoother))
	var motion = velocity
	move(motion)

	# determine if collision is occuring, get collision normal, set motion and velocity to be along normal path and move
	if (is_colliding()):
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		velocity = normal.slide(velocity)
		move(motion)

	#
	# IDLE
	#
	if (not is_attacking and not is_moving and not is_hit):
		play_sprite_animation("idle")

	#
	# ATTACK
	#
	# check for special key input, if attacking then stop, else attack
	if (Input.is_action_pressed("player_one_special") and not is_moving):
		if (is_attacking):
			stop_sprite_animation()
			is_attacking = false
		else:
			if stamina > 0:
				is_attacking = true
				play_sprite_animation("special")
	# check for punch key input, if attacking then stop, else attack
	if (Input.is_action_pressed("player_one_punch")):
		if (is_attacking):
			stop_sprite_animation()
			is_attacking = false
		else:
			play_sprite_animation("punch")

	if health < 1:
		is_dead = true
		play_audio_sample("dead")
		play_sprite_animation("dead")
		# quick hack to stop loop, not sure if this should be done????
		set_fixed_process(false)

func play_sprite_animation(animation_name):
	sprite.play(animation_name)

func stop_sprite_animation():
	sprite.stop()

func play_audio_sample(sample_name):
	audio.play(sample_name)