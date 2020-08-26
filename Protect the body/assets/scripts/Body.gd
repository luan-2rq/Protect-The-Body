extends KinematicBody2D


onready var max_lifes = 3
onready var lifes = max_lifes

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		lifes -= 1
		var pointer = get_parent().pointer
		pointer.respawn()
		clean()

func clean():
	for x in get_tree().get_nodes_in_group("enemy"):
			x.free()
