extends "state_machine.gd"

#NOTE refactor to include accessible state machine for enemies / world interaction
#

# constants
# movement
const WALK_SPEED = 0.025
# variables
# movement
var velocity = Vector2()
var slide_count = 0
var slide_limit = 2
# character state
var character_state = "idle"
export var is_attacking = false
export var is_hit = false
export var is_moving = false
export var is_dead = false
# character status
# export to editor (see value sliders on the right)
export var health = 200
export var stamina = 100
export var damage = 10
# resources
var sprite
var audio
var collision
# audio
var audio_limiter = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_unhandled_input(true)
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
	if (Input.is_action_pressed("player_one_left") and not is_attacking || is_hit and not is_moving):
		set_state("moving")
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		sprite.set_flip_h(true)
		#velocity.x -= WALK_SPEED
		move_local_x(-1)
	if (Input.is_action_pressed("player_one_right") and not is_attacking || is_hit and not is_moving):
		set_state("moving")
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		sprite.set_flip_h(false)
		#velocity.x += WALK_SPEED
		move_local_x(1)
	if (Input.is_action_pressed("player_one_up") and not is_attacking || is_hit and not is_moving):
		set_state("moving")
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		#velocity.y -= WALK_SPEED
		move_local_y(-1)
	if (Input.is_action_pressed("player_one_down") and not is_attacking || is_hit and not is_moving):
		set_state("moving")
		is_moving = true
		slide_count = 0
		play_sprite_animation("walk")
		#velocity.y += WALK_SPEED
		move_local_y(1)
	
	# check slide_count, set velocity (x,y) to 0, and if not attacking set animation to idle
	slide_count += 1
	if (is_moving and slide_count > slide_limit):
		velocity = Vector2(0,0)
		if not (is_attacking):
			is_moving = false
			play_sprite_animation("idle")
			set_state("idle")
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

	if (is_colliding() and is_attacking):
		# get enemy node and position
		pass

	#
	# IDLE
	#
	#if (not is_attacking and not is_moving and not is_hit):
	#	play_sprite_animation("idle")

	if health < 1:
		set_state("dead")
		is_dead = true
		play_audio_sample("guitar_dude_dead")
		play_sprite_animation("dead")
	
func _unhandled_input(event):
	if (event.is_action_pressed("player_one_punch") and not event.is_echo()):
		attack("punch")
		set_state("attacking")
		play_audio_sample("punchmiss1")
	if (event.is_action_pressed("player_one_special") and not event.is_echo()):
		special("special")
		set_state("special")

# for loop-enabled animations
func play_sprite_animation(animation_name):
	sprite.play(animation_name)

# stop animation from playing
func stop_sprite_animation():
	sprite.stop()

# for loopable audio samples
func play_audio_sample(sample_name):
	audio.play(sample_name)

# stop audio sample from playing
func stop_audio_sample():
	audio.stop_all()

# for attack, reset frame and play attack animation
func attack(animation_name):
	sprite.set_frame(0)
	sprite.play(animation_name)

# for special
func special(animation_name):
	sprite.play(animation_name)

func set_state(state):
	character_state = state

func get_state():
	return character_state

func set_status():
	pass

func get_status():
	var character_status = {"health": health, "stamina": stamina}
	return character_status
	
func set_health(damage):
	health -= damage

func get_health():
	return health
	