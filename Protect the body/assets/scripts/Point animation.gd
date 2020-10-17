extends Node2D

onready var points = 100

func _ready():
	$Label.text = "x" + String(points * (get_parent().get_parent().get_node("Combo").counter + 1) * get_parent().points_mult)
