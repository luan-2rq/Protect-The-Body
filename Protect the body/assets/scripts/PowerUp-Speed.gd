extends PowerUp

signal speedup

func die():
	emit_signal("speedup")
	call_deferred("free")
