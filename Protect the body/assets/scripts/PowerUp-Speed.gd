extends KinematicBody2D

func collected():
	Global.velocity_modifier += 0.25
	queue_free()
