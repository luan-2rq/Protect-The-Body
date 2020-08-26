extends PowerUp

signal restore

func collected():
	emit_signal("restore")
	call_deferred("free")
