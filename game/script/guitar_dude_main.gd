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
	print(get_state())
	state.update(delta)

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