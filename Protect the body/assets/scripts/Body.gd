extends KinematicBody2D


onready var lifes = 3

func _ready():
	pass



func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		lifes -= 1
		print(lifes)
		get_tree().paused = true
		for x in get_tree().get_nodes_in_group("enemy"):
			x.free()
		get_tree().paused = false
