extends Control

signal start

func _on_Anim_animation_finished(anim_name):
	if (anim_name == "Panel_show"):
		$Anim.play("Panel_hide")
	else:
		emit_signal("start")

func _on_Timer_timeout():
	$Anim.play("Panel_show")
