extends Control

onready var points : int = 0

func on_Enemy_die():
	$Points.text = String(points)

