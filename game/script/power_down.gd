extends Sprite

func _ready():
	pass

func _on_power_down_collision_body_enter( body ):
	if body.has_method("set_health"):
		body.set_health(50, "sub")
		queue_free()
