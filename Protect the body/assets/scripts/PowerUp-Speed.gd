extends PowerUp

signal speedup

func collected():
	emit_signal("speedup")
	call_deferred("free")
