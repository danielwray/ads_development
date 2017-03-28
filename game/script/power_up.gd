extends Sprite

func _ready():
	pass

func _on_power_up_collision_body_enter( body ):
	if body.has_method("set_health"):
		body.set_health(25, "add")
		queue_free()
