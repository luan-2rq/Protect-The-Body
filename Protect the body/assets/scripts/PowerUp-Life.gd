extends PowerUp

signal restore

func die():
	emit_signal("restore")
	call_deferred("free")
