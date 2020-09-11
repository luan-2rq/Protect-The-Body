extends PowerUp

export(PackedScene) var shield_scene

signal shield(shield_scene)

func die():
	emit_signal("shield", shield_scene)
	call_deferred("free")
