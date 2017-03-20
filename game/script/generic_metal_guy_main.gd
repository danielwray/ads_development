extends KinematicBody2D

# TODO refactor entire script to abstract from enemy_sprite
# - abstract references to exported vars
# - rename scene to enemies
# - include sub-groups from main node that contains multiple characters
# - instance scene and reference enemy character type

# get player object (first) from player group - will tackle multiplayer later
onready var player = get_tree().get_nodes_in_group("player")[0]
# TODO : Implement code to check player group and find nearest character
onready var state = Moving.new(self, player)

# constants
const STATE_IDLE		= "SI"
const STATE_MOVING		= "SM"
const STATE_ATTACKING	= "SA"
const STATE_SPECIAL		= "SS"
const STATE_HIT			= "SH"
const STATE_DEAD		= "SD"

# variables
# root scene variables
var root = null
# movement
var get_current_pos
var death_count = 0
var dead_timer = 0
var is_dead = false
# resources
var sprite
var audio
var collision
var enemy_name_label
var enemy_health_bar
# state parameters
var previous_state = ""
var current_state  = ""
var next_state     = ""
var state_action_timer = 0
var state_action_timer_limit = 1.0
var state_timer    = 0
var state_timer_limit = 1.0
var dead_counter = 0
var dead_counter_limit = 200
var special_dead = false

# character parameters
var health = 50 + init.get_difficulty()
var damage = 0.2 + init.get_difficulty()
var speed = 0.2 * init.get_difficulty()

# refactor to be in an external json file
# {"band name": ["health", "damage", "speed"]}
var enemy_name_dict = {
	"Metallica": [health, 0.5, 1.0],
	"Kiss": [health, 0.2, 2.0],
	"Manowar": [health, 1.65, 2.0],
	"Slayer": [health, 1.4, 1.0],
	"Rage Against the Machine": [health, 0.5, 1.0],
	"Queen": [health, 2.75, 0.5],
	"Abba": [health, 1.2, 1.0],
	"Anthrax": [health, 1.8, 2.5],
	"Frank Zappa": [health, 1.1, 1.0],
	"Queens of the Stone Age": [health, 0.2, 1.0],
	"Wintersun": [health, 1.1, 1.0],
	"Some band 1": [health, 0.5, 1.0],
	"Some band 2": [health, 1.5, 1.0],
	"Hipster Bastard": [health, 2.1, 1.0]
}

func _ready():
	set_fixed_process(true)
	#set_pos(Vector2(800, 350))
	# get root node
	var _root=get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)
	# set enemy stats
	var enemy_stats = enemy_name_dict.keys()[randi() % enemy_name_dict.size()]
	health = enemy_name_dict[enemy_stats][0]
	damage = enemy_name_dict[enemy_stats][1]
	speed = enemy_name_dict[enemy_stats][2]
	# set enemy name
	enemy_name_label = get_node(get_node_objects().name)
	enemy_name_label.set_text(str(enemy_name_dict.keys()[randi() % enemy_name_dict.size()]) + " Fan")
	# set enemy health bar
	enemy_health_bar = get_node(get_node_objects().health)
	enemy_health_bar.set_value(health)
	# set collision direction (vector) - this allows enemy to pass through each other, prior to this they would block each other
	set_one_way_collision_direction(Vector2(-1,0))

func _fixed_process(delta):
	var collider
	# if enemy health is greater than 0 and raycaster is colliding
	# check if collider object (i.e. player) has method (is_in_group)
	# if true check the object is in player group and trigger attack
	if get_health() > 0:
		enemy_health_bar.set_value(health)
		if not get_state() == "SH":
			state.update(delta)
			if get_node(get_node_objects().raycast).is_colliding():
				collider = get_node(get_node_objects().raycast).get_collider()
				# collider.has_method("is_in_group")
				if collider ==  get_tree().get_nodes_in_group("player")[0]:
					if get_node(get_node_objects().raycast).get_collider().is_in_group("player"):
						trigger_attack_state()
			else:
				set_state("SM")
		else:
			if state_timer > state_timer_limit:
				set_state("SM")
				state_timer = 0
			state_timer += 0.1
	else:
		enemy_health_bar.hide()
		enemy_name_label.hide()
		set_state("SD")
		dead_counter += 1
		if dead_counter > dead_counter_limit:
			delete()

# body is other collision object - if body is in group player then set self state to SA
func trigger_attack_state():
	set_state("SA")

func set_state(new_state):
	state.exit()
	if new_state == STATE_DEAD:
		state = Dead.new(self)
		state.dead(special_dead)
	elif new_state == STATE_IDLE:
		state = Idle.new(self)
	elif new_state == STATE_MOVING:
		state = Moving.new(self, player)
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
	var enemy
	var enemy_sprite
	var enemy_collision
	var enemy_audio

	func _init(enemy):
		self.enemy = enemy
		enemy_sprite = enemy.get_node(enemy.get_node_objects().sprite)
		enemy_collision = enemy.get_node(enemy.get_node_objects().collision)
		enemy_audio = enemy.get_node(enemy.get_node_objects().audio)

	func update(delta):
		enemy_sprite.play("idle")
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
	var enemy
	var enemy_sprite
	var enemy_collision
	var enemy_audio
	var enemy_raycast
	var player

	func _init(enemy_root, player):
		self.enemy = enemy_root
		self.player = player
		enemy_sprite = enemy.get_node(enemy.get_node_objects().sprite)
		enemy_collision = enemy.get_node(enemy.get_node_objects().collision)
		enemy_audio = enemy.get_node(enemy.get_node_objects().audio)
		enemy_raycast = enemy.get_node(enemy.get_node_objects().raycast)

	func update(delta):
		on_move(player)
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
		var walk_speed = enemy.get_speed()
		var player_node = player
		var attack_zone_limit = 500
		
		# work out length to player, and angle for sprite flip control
		player_pos = player_node.get_pos()
		get_current_pos = enemy.get_pos()
		delta_x = player_pos.x - get_current_pos.x
		delta_y = player_pos.y - get_current_pos.y
		angle_in_radians = atan2(delta_x, delta_y)
		length = sqrt(delta_x * delta_x + delta_y * delta_y)
		length_to_player_x = delta_x / length
		length_to_player_y = delta_y / length

		# control direction of enemy
		if (enemy.get_angle_to(player_pos) > 0.5):
			enemy_sprite.set_flip_h(false)
			enemy_raycast.set_rot(6)
		else:
			enemy_sprite.set_flip_h(true)
			enemy_raycast.set_rot(-160)

		# determine if enemy should start moving
		if length > attack_zone_limit:
			enemy.set_state("SI")
		else:
			enemy_sprite.play("walk")
			# will keep enemy moving unless within 5 pixels of player
			if length_to_player_x or length_to_player_y > 0:
				enemy.move(Vector2(length_to_player_x * walk_speed, length_to_player_y * walk_speed))
				enemy_sprite.play("walk")
			else:
				enemy_sprite.set_state("SI")
			# determine z value of character (0 if above half screen, 1 if below)
			if enemy.get_pos().y < window_size.y / 2:
				enemy.set_z(int(enemy.get_pos().y))
			elif enemy.get_pos().y > window_size.y / 2:
				enemy.set_z(int(enemy.get_pos().y))



	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SA
# ------------------------------------------------------------------------------------------------------#
class Attacking:
	var enemy
	var enemy_sprite
	var enemy_collision
	var enemy_audio
	var enemy_raycast

	func _init(enemy_root):
		self.enemy = enemy_root
		enemy_sprite = enemy.get_node(enemy.get_node_objects().sprite)
		enemy_collision = enemy.get_node(enemy.get_node_objects().collision)
		enemy_audio = enemy.get_node(enemy.get_node_objects().audio)
		enemy_raycast = enemy.get_node(enemy.get_node_objects().raycast)

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
		player_object_id = enemy_raycast.get_collider()
		var random_determinator = randi()%11+1
		if random_determinator > 8:
			if player_object_id.has_method("is_in_group") and player_object_id.is_in_group("player"):
				if player_object_id.get_state() == "SD":
					enemy.set_state("SI")
				else:
					# we need to set the player state to hit else the hit() function is not available
					# I don't like this, and don't feel it is the proper way to handle interaction and triggers
					# but it'll do for now, and we can change it later on.
					player_object_id.set_state("SH")
					player_object_id.state.hit(enemy.get_damage())
					enemy_sprite.play("punch")
					if not enemy_audio.is_active():
						enemy_audio.play("enemy_punch_1")
					enemy.set_state("SM")
			else:
				enemy.set_state("SM")


	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SH
# ------------------------------------------------------------------------------------------------------#
class Hit:
	var enemy
	var enemy_sprite
	var enemy_collision
	var enemy_audio
	var state_action_timer = 0
	var state_action_limit = 1.0

	func _init(enemy_root):
		self.enemy = enemy_root
		enemy_sprite = enemy.get_node(enemy.get_node_objects().sprite)
		enemy_collision = enemy.get_node(enemy.get_node_objects().collision)
		enemy_audio = enemy.get_node(enemy.get_node_objects().audio)

	func update(delta):
		pass

	func hit(damage):
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################
		if enemy.get_health() < 0:
			enemy.set_state("SD")
		else:
			enemy_sprite.play("hit")
			enemy.health -= damage

	func hit_special(damage):
		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################
			enemy.health -= damage
			enemy_sprite.play("hit_special")
			enemy.special_dead = true
			enemy.set_state("SD")

	func exit():
		pass

# ------------------------------------------------------------------------------------------------------#
# STATE: SD
# ------------------------------------------------------------------------------------------------------#
class Dead:
	var enemy
	var enemy_sprite
	var enemy_collision
	var enemy_audio
	var status


	func _init(enemy_root):
		self.enemy = enemy_root
		enemy_sprite = enemy.get_node(enemy.get_node_objects().sprite)
		enemy_collision = enemy.get_node(enemy.get_node_objects().collision)
		enemy_audio = enemy.get_node(enemy.get_node_objects().audio)

	func update(delta):
		pass

	func dead(special_dead):
		if special_dead:
			enemy_sprite.play("hit_special")
			if not enemy_audio.is_active() and enemy.is_dead == false:
				enemy_audio.play("enemy_dead_1")
				enemy.is_dead = true
		else:
			enemy_sprite.play("dead")
			if not enemy_audio.is_active() and enemy.is_dead == false:
				enemy_audio.play("enemy_dead_1")
				enemy.is_dead = true

		#################################################################################################
		# TODO - Bertie: Audio code goes here
		# See 'samplePlayer2D' class for available methods
		#################################################################################################

	func exit():
		pass

# get functions
func get_health():
	return health

func get_damage():
	return damage

func get_speed():
	return speed

func get_node_objects():
	var sprite = get_node("sprite").get_name()
	var collision = get_node("collision").get_name()
	var audio = get_node("audio").get_name()
	var raycast = get_node("raycast").get_name()
	var health = get_node("health").get_name()
	var name = get_node("name").get_name()
	var node_dict = {
	"sprite": sprite, "collision": collision, "audio": audio,
	"raycast": raycast, "health": health, "name": name
	}
	var node_list = [name, health, sprite, collision, raycast, audio]
	return node_dict

# set functions

# clear up
func delete():
	remove_from_group("enemy")
	queue_free()
