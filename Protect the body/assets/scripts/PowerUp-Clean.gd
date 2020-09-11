extends PowerUp

signal clean

func die():
	emit_signal("clean")
	call_deferred("free")
