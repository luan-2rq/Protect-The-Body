extends PowerUp

signal fruitninja

func die():
	emit_signal("fruitninja")
	call_deferred("free")
