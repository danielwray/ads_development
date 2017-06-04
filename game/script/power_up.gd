extends Sprite

func _ready():
	pass

func _on_power_up_collision_body_enter( body ):
	if body.has_method("set_health"):
		if self.is_in_group('beer'):
			power_up(body, 50, "health_burp")
		elif self.is_in_group("burger"):
			power_up(body, 25, "health_fart_2")
		elif self.is_in_group("burrito"):
			power_up(body, 100, "health_burritos")
		else:
			power_up(body, 0, "health_burp")

func power_up(body, value, audio):
	body.set_health(value, "add")
	body.play_audio(audio)
	queue_free()