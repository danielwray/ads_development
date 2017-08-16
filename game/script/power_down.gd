extends Sprite

func _ready():
	pass

func _on_power_down_collision_body_enter( body ):
	if body.has_method("set_health"):
		if self.is_in_group('apple'):
			power_down(body, 50, "health_crunch")
		else:
			power_down(body, 0, "health_crunch")

func power_down(body, value, audio):
	body.set_health(value, "sub")
	body.play_audio(audio)
	queue_free()