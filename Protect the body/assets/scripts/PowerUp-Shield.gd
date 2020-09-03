extends PowerUp

export(PackedScene) var shield_scene

signal shield(shield_scene)

func collected():
	emit_signal("shield", shield_scene)
	call_deferred("free")
