extends KinematicBody2D

# TODO refactor entire script to abstract from generic_metal_guy
# - abstract references to exported vars
# - rename scene to enemies
# - include sub-groups from main node that contains multiple characters
# - instance scene and reference enemy character type


# TODO : Implement code to check player group and find nearest character
onready var state = Moving.new(self, get_node("../guitar_dude"))

# constants
const STATE_IDLE		= "SI"
const STATE_MOVING		= "SM"
const STATE_ATTACKING	= "SA"
const STATE_SPECIAL		= "SS"
const STATE_HIT			= "SH"
const STATE_DEAD		= "SD"
# preload scripts
const player = preload("guitar_dude_main.gd")

# variables
# root scene variables
var root = null
# movement
var get_current_pos
var death_count = 0
var dead_timer = 0
# resources
var sprite
var audio
var collision
var enemy_name_label
# state parameters
var previous_state = ""
var current_state  = ""
var next_state     = ""
var state_timer    = 0
var state_timer_limit = 1.0
var dead_counter = 0
var dead_counter_limit = 200
# character parameters
export var health = 100
var enemy_name_list = ["Generic Metal Guy"]
var enemy_health_bar

func _ready():
	set_fixed_process(true)
	#set_pos(Vector2(800, 350))
	# get root node
	var _root=get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)
	# set enemy name
	enemy_name_label = get_node("generic_metal_guy_name")
	enemy_name_label.set_text(str(enemy_name_list[randi() % enemy_name_list.size()]))
	# set enemy health bar
	enemy_health_bar = get_node("generic_metal_guy_health")
	enemy_health_bar.set_value(health)

func _fixed_process(delta):
	# if enemy health is greater than 0 and raycaster is colliding
	# check if collider object (i.e. player) has method (is_in_group)
	# if true check the object is in player group and trigger attack
	if health > 0:
		enemy_health_bar.set_value(health)
		state.update(delta)
		if get_node("generic_metal_guy_raycast_right").is_colliding():
			var collider = get_node("generic_metal_guy_raycast_right").get_collider()
			if collider.has_method("is_in_group"):
				if get_node("generic_metal_guy_raycast_right").get_collider().is_in_group("player"):
					trigger_attack_state()
		else:
			set_state("SM")
	else:
		enemy_health_bar.hide()
		enemy_name_label.hide()
		set_state("SD")
		dead_counter += 1
		if dead_counter > dead_counter_limit:
			queue_free()

# body is other collision object - if body is in group player then set self state to SA
func trigger_attack_state():
	set_state("SA")

func set_state(new_state):
	state.exit()
	if new_state == STATE_DEAD:
		state = Dead.new(self)
		state.dead()
	elif new_state == STATE_IDLE:
		state = Idle.new(self)
	elif new_state == STATE_MOVING:
		state = Moving.new(self, get_node("../guitar_dude"))
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
	var generic_metal_guy_raycast_right
	var player
	
	func _init(generic_metal_guy, player):
		self.generic_metal_guy = generic_metal_guy
		self.player = player
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")
		generic_metal_guy_raycast_right = generic_metal_guy.get_node("generic_metal_guy_raycast_right")

	func update(delta):
		on_move(player)
		generic_metal_guy_sprite.play("walk")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func on_move(player):
		var window_size = OS.get_window_size()
		var player_node
		var player_pos
		var get_current_pos
		var delta_x
		var delta_y
		var angle_in_radians
		var length
		var length_to_player_x
		var length_to_player_y
		var walk_speed = 0.5
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
			generic_metal_guy_raycast_right.set_rot(6)
		else:
			generic_metal_guy_sprite.set_flip_h(true)
			generic_metal_guy_raycast_right.set_rot(-160)

		# determine z value of character (0 if above half screen, 1 if below)
		if generic_metal_guy.get_pos().y < window_size.y / 2:
			generic_metal_guy.set_z(int(generic_metal_guy.get_pos().y))
		elif generic_metal_guy.get_pos().y > window_size.y / 2:
			generic_metal_guy.set_z(int(generic_metal_guy.get_pos().y))
			generic_metal_guy.move(Vector2(length_to_player_x * walk_speed, length_to_player_y * walk_speed))
			generic_metal_guy_sprite.play("walk")
		else:
			generic_metal_guy.set_state("SI")

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SA
# ------------------------------------------------------------------------------------------------------#
class Attacking:
	var damage = 1
	var generic_metal_guy
	var generic_metal_guy_sprite
	var generic_metal_guy_collision
	var generic_metal_guy_audio
	var generic_metal_guy_raycast_right
	
	func _init(generic_metal_guy):
		self.generic_metal_guy = generic_metal_guy
		generic_metal_guy_sprite = generic_metal_guy.get_node("generic_metal_guy_sprite")
		generic_metal_guy_collision = generic_metal_guy.get_node("generic_metal_guy_collision")
		generic_metal_guy_audio = generic_metal_guy.get_node("generic_metal_guy_audio")
		generic_metal_guy_raycast_right = generic_metal_guy.get_node("generic_metal_guy_raycast_right")

	func update(delta):
		attack()
	
	
	func attack():
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		# if get_state of player is hit then collision has been detected and hit function ran against player
		# elif player is dead set self to idle
		# else move towards player
		#################################################################################################
		
		# TODO - fix bug with right / left raycast being null
		var player_object_id
		player_object_id = generic_metal_guy_raycast_right.get_collider()
		var random_determinator = randi()%11+1
		if random_determinator > 8:
			if player_object_id.has_method("is_in_group") and player_object_id.is_in_group("player"):
				if player_object_id.get_state() == "SD":
					generic_metal_guy.set_state("SI")
				else:
					# we need to set the player state to hit else the hit() function is not available
					# I don't like this, and don't feel it is the proper way to handle interaction and triggers
					# but it'll do for now, and we can change it later on.
					player_object_id.set_state("SH")
					player_object_id.state.hit(damage)
					generic_metal_guy_sprite.play("punch")
					generic_metal_guy.set_state("SM")
			else:
				generic_metal_guy.set_state("SM")


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
		generic_metal_guy.set_state("SD")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func hit(damage):
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################
		if generic_metal_guy.health < 0:
			generic_metal_guy.set_state("SD")
		else:
			generic_metal_guy.health -= damage
			generic_metal_guy_sprite.play("hit")

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
		generic_metal_guy.set_state("SD")

	func dead():
		generic_metal_guy_sprite.play("dead")
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func exit():
		pass

func get_health():
	return health