extends PowerUp

signal clean

func collected():
	emit_signal("clean")
	call_deferred("free")
