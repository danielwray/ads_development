extends KinematicBody2D

onready var state = Idle.new(self)

# constants
const STATE_IDLE		= "SI"
const STATE_MOVING		= "SM"
const STATE_ATTACKING	= "SA"
const STATE_SPECIAL		= "SS"
const STATE_HIT			= "SH"
const STATE_DEAD		= "SD"

func _ready():
	set_fixed_process(true)
	set_process_unhandled_input(true)
	set_pos(Vector2(120, 120))

func _fixed_process(delta):
<<<<<<< HEAD
	print(get_state())
	state.update(delta)
=======
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
		is_colliding_and_is_attacking = true

	#
	# IDLE
	#
	#if (not is_attacking and not is_moving and not is_hit):
	#	play_sprite_animation("idle")

	if health < 1:
		set_state("dead")
		if not is_dead:
			is_dead = true
			play_audio_sample("guitar_dude_dead")
			play_sprite_animation("dead")
			set_fixed_process(false)
		
func _unhandled_input(event):
	if (event.is_action_pressed("player_one_punch") and not event.is_echo()):
		attack("punch")
		set_state("attacking")
		if is_colliding_and_is_attacking:
			play_audio_sample("punch_1")
		else:
			play_audio_sample("punch_miss_1")
	if (event.is_action_pressed("player_one_special") and not event.is_echo()):
		special("special")
		set_state("special")
>>>>>>> fd726e8fe93e2868c285e9f8c2f1c82bcb259370

func _unhandled_input(event):
	if Input.is_action_pressed("player_one_up"):
		set_state("SM")
		state.on_move("y", -1, false, false)
	elif Input.is_action_pressed("player_one_down"):
		set_state("SM")
		state.on_move("y", 1, false, false)
	if Input.is_action_pressed("player_one_left"):
		set_state("SM")
		state.on_move("x", -1, true, false)
	elif Input.is_action_pressed("player_one_right"):
		set_state("SM")
		state.on_move("x", 1, false, false)
	if Input.is_action_pressed("player_one_punch"):
		set_state("SA")
		state.attack()
	if Input.is_action_pressed("player_one_special"):
		set_state("SS")
		state.special()

func set_state(new_state):
	state.exit()
	if new_state == STATE_IDLE:
		state = Idle.new(self)
	elif new_state == STATE_MOVING:
		state = Moving.new(self)
	elif new_state == STATE_ATTACKING:
		state = Attacking.new(self)
	elif new_state == STATE_SPECIAL:
		state = Special.new(self)
	elif new_state == STATE_HIT:
		state = Hit.new(self)
	elif new_state == STATE_DEAD:
		state = Dead.new(self)

func get_state():
	if state extends Idle:
		return STATE_IDLE
	elif state extends Moving:
		return STATE_MOVING
	elif state extends Attacking:
		return STATE_ATTACKING
	elif state extends Special:
		return STATE_SPECIAL
	elif state extends Hit:
		return STATE_HIT
	elif state extends Dead:
		return STATE_DEAD

# ------------------------------------------------------------------------------------------------------#
# STATE: SI
# ------------------------------------------------------------------------------------------------------#
class Idle:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		guitar_dude_sprite.play("idle")

	func input(event):
		pass

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SM
# ------------------------------------------------------------------------------------------------------#
class Moving:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	var slide_count = 0
	var slide_limit = 10
	var velocity = Vector2()
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")
	
	func update(delta):
		slide_count += 1
		if (slide_count > slide_limit):
			guitar_dude.set_state("SI")
	
	func input(event):
		pass
	
	func on_move(axis, value, flip_h, flip_v):
		guitar_dude_sprite.play("walk")
		if axis == "x":
			guitar_dude.move_local_x(value)
			guitar_dude_sprite.set_flip_h(flip_h)
			slide_count = 0
		else:
			guitar_dude.move_local_y(value)
			guitar_dude_sprite.set_flip_v(flip_v)
			slide_count = 0


	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SA
# ------------------------------------------------------------------------------------------------------#
class Attacking:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		guitar_dude_sprite.play("idle")

	func input(event):
		pass
	
	func attack():
		guitar_dude_sprite.play("punch")
		print("pow")
		#guitar_dude_audio.play("dead")

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SS
# ------------------------------------------------------------------------------------------------------#
class Special:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		guitar_dude_sprite.play("idle")

	func input(event):
		pass
	
	func special():
		pass

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SH
# ------------------------------------------------------------------------------------------------------#
class Hit:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		guitar_dude_sprite.play("idle")

	func input(event):
		pass
	
	func hit():
		pass

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SD
# ------------------------------------------------------------------------------------------------------#
class Dead:
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		guitar_dude_sprite.play("idle")

	func input(event):
		pass
	
	func dead():
		pass

	func exit():
		pass