extends PowerUp

signal fruitninja

func collected():
	emit_signal("fruitninja")
	call_deferred("free")
