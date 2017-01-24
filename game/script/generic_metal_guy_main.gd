extends KinematicBody2D

# constants

# variables
# movement
var get_current_pos
var death_count = 0
# state
var character_state
export var is_attacking = false
export var is_hit = false
export var is_moving = false
export var is_dead = false
# status
export var health = 150
export var damage = 5
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
	
	

	# if instance is colliding and collision is with guitar_dude and guitar_dude is attacking
	if is_colliding() and get_collider().get_name() == "guitar_dude" and guitar_dude_state == "attacking":
		if can_be_hit:
			play_sprite_animation("hit")
			health -= 1
			set_state("hit")
			can_be_hit = false
	# else if guitar_dude is doing special then take off damage all instances of enemy
	elif guitar_dude_state == "special":
		play_sprite_animation("hit")
		health -= 1
		set_state("hit")
	# else enemy can attack guitar_dude
	elif is_colliding() and get_collider().get_name() == "guitar_dude" and guitar_dude_state == "idle" or guitar_dude_state == "moving":
		attack("punch")
		guitar_dude.set_health(damage)
		set_state("attacking")
		can_be_hit = true
	else:
		play_sprite_animation("idle")
		set_state("idle")

	# flip if angle positive (left of character)
	if (get_angle_to(guitar_dude_pos) > 0.5):
		sprite.set_flip_h(false)
	else:
		sprite.set_flip_h(true)

	# if not at guitar_dude's position then move towards it
	if not (guitar_dude_pos == get_pos()):
		get_current_pos = get_pos()
		move_to(guitar_dude_pos).slide(guitar_dude_pos)
		#play_sprite_animation("walk")
		set_state("moving")

	if health < 1:
		is_dead = true
		play_sprite_animation("dead")
		# quick hack to stop loop, not sure if this should be done????
		get_node("generic_metal_guy_collision").remove_and_skip()
		set_state("dead")
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