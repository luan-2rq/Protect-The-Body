extends Node2D

export var hits : int = 2

func _physics_process(_delta):
	if hits == 0:
		self.call_deferred("free")

func _on_Area2D_body_entered(body):
	if(body.is_in_group("enemy")):
		body.call_deferred("free")
		hits -= 1
