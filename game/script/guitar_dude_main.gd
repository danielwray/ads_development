extends KinematicBody2D

onready var state = Idle.new(self)

# constants
const STATE_IDLE		= "SI"
const STATE_MOVING		= "SM"
const STATE_ATTACKING	= "SA"
const STATE_SPECIAL		= "SS"
const STATE_HIT			= "SH"
const STATE_DEAD		= "SD"
# variables
# state parameters
var previous_state = ""
var current_state  = ""
var next_state     = ""
var state_timer    = 0
var state_timer_limit = 1.0
var is_moving = false
var move_cool_down_timer = 0
# character parameters
export var health    = 100
export var damage    = 1
export var special   = 5
export var new_state = "SI"
# util variables
var window_size

func _ready():
	set_state(new_state)
	set_fixed_process(true)
	set_process_unhandled_key_input(true)
	set_process_input(true)
	set_pos(Vector2(120, 300))

func _fixed_process(delta):
	if not get_state() == "SD":
		state.update(delta)
		trigger_collision()
		trigger_movement()
		if move_cool_down_timer > 1:
			is_moving = false
			move_cool_down_timer = 0
		move_cool_down_timer += 0.95
	else:
		set_fixed_process(false)
		set_process_unhandled_input(false)

func trigger_collision():
	# if collision is true trigger on hitbox function
	if is_colliding() and is_in_group("enemy"):
		_on_Hitbox_body_enter(get_collider())
		get_collider().get_instance_ID()

func trigger_movement():
	is_moving = true
	if Input.is_action_pressed("player_one_up"):
		previous_state = get_state()
		set_state("SM")
		current_state = get_state()
		state.on_move("y", -2, false, false)
	if Input.is_action_pressed("player_one_down"):
		previous_state = get_state()
		set_state("SM")
		current_state = get_state()
		state.on_move("y", 2, false, false)
	if Input.is_action_pressed("player_one_left"):
		previous_state = get_state()
		set_state("SM")
		current_state = get_state()
		state.on_move("x", -2, true, false)
	if Input.is_action_pressed("player_one_right"):
		previous_state = get_state()
		set_state("SM")
		current_state = get_state()
		state.on_move("x", 2, false, false)

func _input(event):
	print(event)
	if Input.is_action_pressed("player_one_punch") and not is_moving and not get_state() == "SD":
		previous_state = get_state()
		set_state("SA")
		current_state = get_state()
		state.attack()
	elif Input.is_action_pressed("player_one_special") and not is_moving and not get_state() == "SD":
		previous_state = get_state()
		set_state("SS")
		current_state = get_state()
		state.special()

# body is other collision object - if body is in group player then set self state to SA
func _on_Hitbox_body_enter( body ):
	if body.is_colliding() and body.is_in_group("enemy") and not get_state() == "SA":
		set_state("SH")

func _unhandled_key_input(event):
	pass

func set_state(new_state):
	state.exit()
	if new_state == STATE_DEAD:
		state = Dead.new(self)
		state.dead()
	elif new_state == STATE_IDLE:
		state = Idle.new(self)
	elif new_state == STATE_MOVING:
		state = Moving.new(self)
	elif new_state == STATE_ATTACKING:
		state = Attacking.new(self)
	elif new_state == STATE_SPECIAL:
		state = Special.new(self)
	elif new_state == STATE_HIT:
		state = Hit.new(self)

func get_state():
	if state extends Dead:
		return STATE_DEAD
	elif state extends Idle:
		return STATE_IDLE
	elif state extends Moving:
		return STATE_MOVING
	elif state extends Attacking:
		return STATE_ATTACKING
	elif state extends Special:
		return STATE_SPECIAL
	elif state extends Hit:
		return STATE_HIT

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
		if guitar_dude.get_health() < 100:
			guitar_dude.set_health(0.05, "add")
		if guitar_dude.get_special() < 100:
			guitar_dude.set_special(0.01, "add")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func input(event):
		pass

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SM
# ------------------------------------------------------------------------------------------------------#
class Moving:
	var window_size = init.get_screen_size()
	var guitar_dude
	var guitar_dude_sprite
	var guitar_dude_collision
	var guitar_dude_audio
	var guitar_dude_ray_cast_right
	var state_action_timer = 0
	var slide_count = 0
	var slide_limit = 10
	var velocity = Vector2()
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")
		guitar_dude_ray_cast_right = guitar_dude.get_node("guitar_dude_ray_cast_right")
	
	func update(delta):
		slide_count += 1
		if (slide_count > slide_limit):
			guitar_dude.set_state("SI")
	
	func input(event):
		pass
	
	func on_move(axis, value, flip_h, flip_v):
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################
		guitar_dude_sprite.play("walk")
		if axis == "x":
			guitar_dude.set_state("SM")
			guitar_dude.move(Vector2(value, 0.0))
			guitar_dude_sprite.set_flip_h(flip_h)
			if flip_h:
				guitar_dude_ray_cast_right.set_global_rot(-160)
			else:
				guitar_dude_ray_cast_right.set_global_rot(6)
			slide_count = 0
		else:
			guitar_dude.set_state("SM")
			guitar_dude.move(Vector2(0.0, value))
			guitar_dude_sprite.set_flip_v(flip_v)
			# determine z value of character (0 if above half screen, 1 if below)
			if guitar_dude.get_pos().y < window_size.y / 2:
				guitar_dude.set_z(int(guitar_dude.get_pos().y))
			elif guitar_dude.get_pos().y > window_size.y / 2:
				guitar_dude.set_z(int(guitar_dude.get_pos().y))
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
	var guitar_dude_ray_cast_right
	var guitar_dude_ray_cast_left
	var state_action_timer = 0
	var state_action_limit = 0.25
	var damage
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")
		guitar_dude_ray_cast_right = guitar_dude.get_node("guitar_dude_ray_cast_right")
		damage = guitar_dude.get_damage()

	func update(delta):
		state_action_timer += 0.1
		if state_action_timer > state_action_limit:
			guitar_dude_sprite.stop()
			guitar_dude.set_state("SI")

	func input(event):
		pass
	
	func attack():
		###################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		###################################################################################
		if guitar_dude_ray_cast_right.is_colliding():
			if guitar_dude_ray_cast_right.get_collider().is_in_group("enemy"):
				var enemy_object_id = guitar_dude_ray_cast_right.get_collider().get_instance_ID()
				var enemy_object = instance_from_id(enemy_object_id)
				if enemy_object.has_method("get_state"):
					if enemy_object.get_state() == "SD":
						guitar_dude.set_state("SI")
						return
					else:
						enemy_object.set_state("SH")
						enemy_object.state.hit(damage)
						guitar_dude_sprite.play("punch")
						guitar_dude_audio.play("punch_1")
						if guitar_dude.get_special() < 100:
							guitar_dude.set_special(1, "add")
		else:
			guitar_dude_sprite.play("punch")
			guitar_dude_audio.play("punch_miss_1")


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
	var guitar_dude_special_area
	var guitar_dude_fx_right
	var guitar_dude_fx_left
	var state_action_timer = 0
	var state_action_limit = 2.0
	var stamina = 5
	var damage
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")
		guitar_dude_special_area = guitar_dude.get_node("guitar_dude_special_area")
		guitar_dude_fx_right = guitar_dude.get_node("guitar_dude_fx_right")
		guitar_dude_fx_left = guitar_dude.get_node("guitar_dude_fx_left")
		damage = guitar_dude.get_damage()

	func update(delta):
		state_action_timer += 0.1
		if state_action_timer > state_action_limit:
			guitar_dude_sprite.stop()
			guitar_dude.set_state("SI")
			guitar_dude_fx_right.stop()
			guitar_dude_fx_right.set_frame(0)
			guitar_dude_fx_left.stop()
			guitar_dude_fx_left.set_frame(0)

	func input(event):
		pass
	
	func special():
		# TODO: Include code to play special if stamina is > 0
		if guitar_dude.get_special() > 0:
			for enemy_object in guitar_dude_special_area.get_overlapping_bodies():
				if enemy_object.is_in_group("enemy"):
					enemy_object.set_state("SH")
					enemy_object.state.hit(damage)
					guitar_dude_fx_right.play("lighting")
					guitar_dude_fx_left.play("lighting")
					guitar_dude_sprite.play("special")
					guitar_dude.set_special(stamina, "sub")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

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
	var state_action_timer = 0
	var state_action_limit = 1.0
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		state_action_timer += 0.1
		if state_action_timer > state_action_limit:
			guitar_dude_sprite.stop()
			guitar_dude.set_state("SI")

	func input(event):
		pass
	
	func hit(damage):
		if guitar_dude.get_health() < 0:
			guitar_dude.set_state("SD")
		else:
			guitar_dude.set_health(damage, "sub")
			guitar_dude_sprite.play("hit")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

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
	var state_action_timer = 0
	var state_action_limit = 1.0
	
	func _init(guitar_dude):
		self.guitar_dude = guitar_dude
		guitar_dude_sprite = guitar_dude.get_node("guitar_dude_sprite")
		guitar_dude_collision = guitar_dude.get_node("guitar_dude_collision")
		guitar_dude_audio = guitar_dude.get_node("guitar_dude_audio")

	func update(delta):
		state_action_timer += 0.1
		if state_action_timer > state_action_limit:
			guitar_dude.set_state("SD")

	func input(event):
		pass
	
	func dead():
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################
		guitar_dude_sprite.play("dead")
		guitar_dude_audio.play("guitar_dude_dead")

	func exit():
		pass

# get utility functions
# these functions allow other scripts / objects to retrieve (read only) values from the player instance
func get_damage():
	return damage

func get_health():
	return health

func get_special():
	return special

# set utility functions
# these functions allow internal (or external) objects to update player instance variables
func set_damage(value, operator):
	if operator == "sub":
		damage -= value
	elif operator == "add":
		damage += value

func set_health(value, operator):
	if operator == "sub":
		health -= value
	elif operator == "add":
		health += value

func set_special(value, operator):
	if operator == "sub":
		special -= value
	elif operator == "add":
		special += value

