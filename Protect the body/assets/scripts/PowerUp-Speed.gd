extends PowerUp

func collected():
	Global.velocity_modifier += 0.25
	call_deferred("free")
