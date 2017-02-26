extends KinematicBody2D

# constants

# variables
# movement
var get_current_pos
var death_count = 0
var dead_timer = 0
# state
var character_state
export var is_attacking = false
export var is_hit = false
export var is_moving = false
export var is_dead = false
# status
export var health = 100
export var damage = 1
var can_be_hit
# resources
var sprite
var audio
var collision

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	# load resources
	sprite = get_node("generic_metal_guy_sprite")

func _fixed_process(delta):
	# get guitar_dude node and position
	var guitar_dude = get_node("../guitar_dude")
	var guitar_dude_pos = guitar_dude.get_pos()
	var guitar_dude_state = guitar_dude.get_state()
	
	# if not at guitar_dude's position then move towards it
	if not (guitar_dude_pos == get_pos()):
		set_state("moving")
		# this won't work for multiple enemies, so not sure what to do here... urgh
		get_current_pos = get_pos()
		#move_local_y(get_current_pos.x)
		#move_local_x(get_current_pos.y)
		var delta_x = guitar_dude_pos.x - get_current_pos.x
		var delta_y = guitar_dude_pos.y - get_current_pos.y
		# get angle to player in radians
		# use arctanget of dx, dy
		# atan2(delta_x, delta_y) * 180 / PI to get degrees, but we are working in radians here
		var angle_in_radians = atan2(delta_x, delta_y)
		# get normalized length from guitar_dude to enemy dude
		var length = sqrt(delta_x * delta_x + delta_y * delta_y)
		var length_to_guitar_dude_x = delta_x / length
		var length_to_guitar_dude_y = delta_y / length
		# move enemy towards guitar_dude
		print(length)
		if is_moving:
			if length < 512:
				move(Vector2(length_to_guitar_dude_x * 0.5, length_to_guitar_dude_y * 0.5))
				play_sprite_animation("walk")
			else:
				is_moving = false
				can_be_hit = true
				play_sprite_animation("idle")
		

	# if instance is colliding and collision is with guitar_dude and guitar_dude is attacking
	if is_colliding() and get_collider().get_name() == "guitar_dude" and guitar_dude_state == "attacking":
		if can_be_hit:
			play_sprite_animation("hit")
			health= guitar_dude.damage
			set_state("hit")
			can_be_hit = false
			is_moving = false
	# else if guitar_dude is doing special then take off damage all instances of enemy
	elif guitar_dude_state == "special":
		play_sprite_animation("hit")
		health= 0.1
		set_state("hit")
		is_moving = false
	# else enemy can attack guitar_dude
	elif is_colliding() and get_collider().get_name() == "guitar_dude" and guitar_dude_state == "SI":
		play_sprite_animation("punch")
		guitar_dude.set_state("SD")
		set_state("attacking")
		can_be_hit = true
		is_moving = false
	else:
		is_moving = true
		can_be_hit = true

	# flip if angle positive (left of character)
	if (get_angle_to(guitar_dude_pos) > 0.5):
		sprite.set_flip_h(false)
	else:
		sprite.set_flip_h(true)

	if health < 1:
		is_dead = true
		play_sprite_animation("dead")
		# quick hack to stop loop, not sure if this should be done????
		#get_node("generic_metal_guy_collision").remove_and_skip()
		set_state("dead")
		dead_timer += 1
		if dead_timer > 30:
			queue_free()
			set_fixed_process(false)

# for loop-enabled animations
func play_sprite_animation(animation_name):
	sprite.play(animation_name)

# for attack, reset frame and play attack animation
func attack(animation_name):
	sprite.set_frame(0)
	sprite.play(animation_name)

func set_state(state):
	character_state = state

func get_state():
	return character_state