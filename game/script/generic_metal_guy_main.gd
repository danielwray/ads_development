extends KinematicBody2D

# TODO : Implement code to check player group and find nearest character
onready var state = Moving.new(self, get_node("../guitar_dude"))

# constants
const STATE_IDLE		= "SI"
const STATE_MOVING		= "SM"
const STATE_ATTACKING	= "SA"
const STATE_SPECIAL		= "SS"
const STATE_HIT			= "SH"
const STATE_DEAD		= "SD"

# variables
# movement
var get_current_pos
var death_count = 0
var dead_timer = 0
# resources
var sprite
var audio
var collision
# state parameters
var previous_state = ""
var current_state  = ""
var next_state     = ""
var state_timer    = 0
var state_timer_limit = 1.0
# character parameters
export var health = 100
export var damage = 1

func _ready():
	set_fixed_process(true)
	set_pos(Vector2(400, 400))

func _fixed_process(delta):
	state.update(delta)

func set_state(new_state):
	state.exit()
	if new_state == STATE_DEAD:
		state = Dead.new(self)
	elif new_state == STATE_IDLE:
		state = Idle.new(self)
	elif new_state == STATE_MOVING:
		state = Moving.new(self)
	elif new_state == STATE_ATTACKING:
		state = Attacking.new(self)
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
	elif state extends Hit:
		return STATE_HIT

# ------------------------------------------------------------------------------------------------------#
# STATE: SI
# ------------------------------------------------------------------------------------------------------#
class Idle:
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	
	func _init(generic_metal_guy):
		self.generic_metal_guy = generic_metal_guy
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")

	func update(delta):
		generic_metal_guy_sprite.play("idle")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SM
# ------------------------------------------------------------------------------------------------------#
class Moving:
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	var player
	
	func _init(generic_metal_guy, player):
		self.generic_metal_guy = generic_metal_guy
		self.player = player
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")

	func update(delta):
		on_move(player)
		generic_metal_guy_sprite.play("walk")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func on_move(player):
		var player_node
		var player_pos
		var get_current_pos
		var delta_x
		var delta_y
		var angle_in_radians
		var length
		var length_to_player_x
		var length_to_player_y
		var walk_speed = 0.3
		var player_node = player
		player_pos = player_node.get_pos()
		get_current_pos = generic_metal_guy.get_pos()
		delta_x = player_pos.x - get_current_pos.x
		delta_y = player_pos.y - get_current_pos.y
		angle_in_radians = atan2(delta_x, delta_y)
		length = sqrt(delta_x * delta_x + delta_y * delta_y)
		length_to_player_x = delta_x / length
		length_to_player_y = delta_y / length
		if (generic_metal_guy.get_angle_to(player_pos) > 0.5):
			generic_metal_guy_sprite.set_flip_h(false)
		else:
			generic_metal_guy_sprite.set_flip_h(true)
		if length < 512:
			generic_metal_guy.move(Vector2(length_to_player_x * walk_speed, length_to_player_y * walk_speed))
			generic_metal_guy_sprite.play("walk")

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SA
# ------------------------------------------------------------------------------------------------------#
class Attacking:
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	
	func _init(generic_metal_guy):
		self.generic_metal_guy = generic_metal_guy
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")

	func update(delta):
		generic_metal_guy_sprite.play("punch")
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
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	
	func _init(generic_metal_guy):
		self.generic_metal_guy = generic_metal_guy
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")

	func update(delta):
		generic_metal_guy_sprite.play("hit")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func on_move():
		pass

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SD
# ------------------------------------------------------------------------------------------------------#
class Dead:
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	
	func _init(generic_metal_guy):
		self.generic_metal_guy = generic_metal_guy
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")

	func update(delta):
		generic_metal_guy_sprite.play("dead")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func dead():
		pass

	func exit():
		pass

#func _fixed_process(delta):
#	# get generic_metal_guy node and position
#	var generic_metal_guy = get_node("../generic_metal_guy")
#	var generic_metal_guy_pos = generic_metal_guy.get_pos()
#	var generic_metal_guy_state = generic_metal_guy.get_state()
#	
#	# if not at generic_metal_guy's position then move towards it
#	if not (generic_metal_guy_pos == get_pos()):
#		set_state("moving")
#		# this won't work for multiple enemies, so not sure what to do here... urgh
#		get_current_pos = get_pos()
#		#move_local_y(get_current_pos.x)
#		#move_local_x(get_current_pos.y)
#		var delta_x = generic_metal_guy_pos.x - get_current_pos.x
#		var delta_y = generic_metal_guy_pos.y - get_current_pos.y
#		# get angle to player in radians
#		# use arctanget of dx, dy
#		# atan2(delta_x, delta_y) * 180 / PI to get degrees, but we are working in radians here
#		var angle_in_radians = atan2(delta_x, delta_y)
#		# get normalized length from generic_metal_guy to enemy dude
#		var length = sqrt(delta_x * delta_x + delta_y * delta_y)
#		var length_to_generic_metal_guy_x = delta_x / length
#		var length_to_generic_metal_guy_y = delta_y / length
#		# move enemy towards generic_metal_guy
#		print(length)
#		if is_moving:
#			if length < 512:
#				move(Vector2(length_to_generic_metal_guy_x * 0.5, length_to_generic_metal_guy_y * 0.5))
#				play_sprite_animation("walk")
#			else:
#				is_moving = false
#				can_be_hit = true
#				play_sprite_animation("idle")
#		
#
#	# if instance is colliding and collision is with generic_metal_guy and generic_metal_guy is attacking
#	if is_colliding() and get_collider().get_name() == "generic_metal_guy" and generic_metal_guy_state == "attacking":
#		if can_be_hit:
#			play_sprite_animation("hit")
#			health= generic_metal_guy.damage
#			set_state("hit")
#			can_be_hit = false
#			is_moving = false
#	# else if generic_metal_guy is doing special then take off damage all instances of enemy
#	elif generic_metal_guy_state == "special":
#		play_sprite_animation("hit")
#		health= 0.1
#		set_state("hit")
#		is_moving = false
#	# else enemy can attack generic_metal_guy
#	elif is_colliding() and get_collider().get_name() == "generic_metal_guy" and generic_metal_guy_state == "SI":
#		play_sprite_animation("punch")
#		generic_metal_guy.set_state("SD")
#		set_state("attacking")
#		can_be_hit = true
#		is_moving = false
#	else:
#		is_moving = true
#		can_be_hit = true
#
#	# flip if angle positive (left of character)
#	if (get_angle_to(generic_metal_guy_pos) > 0.5):
#		sprite.set_flip_h(false)
#	else:
#		sprite.set_flip_h(true)
#
#	if health < 1:
#		is_dead = true
#		play_sprite_animation("dead")
#		# quick hack to stop loop, not sure if this should be done????
#		#get_node("generic_generic_metal_guy_collision").remove_and_skip()
#		set_state("dead")
#		dead_timer += 1
#		if dead_timer > 30:
#			queue_free()
#			set_fixed_process(false)
#
 #for loop-enabled animations
#func play_sprite_animation(animation_name):
#	sprite.play(animation_name)
#
# for attack, reset frame and play attack animation
#func attack(animation_name):
#	sprite.set_frame(0)
#	sprite.play(animation_name)
#
#func set_state(state):
#	character_state = state
#
#func get_state():
#	return character_state