extends Node2D

export var hits : int = 2

func _ready():
	$Timer.start()

func _physics_process(_delta):
	if hits == 0:
		self.call_deferred("free")

func _on_Area2D_body_entered(body):
	if(body.is_in_group("enemy")):
		if(body.has_node("Pointer")):
			var pointer = body.get_node("Pointer")
			pointer.respawn()
		body.call_deferred("free")
		hits -= 1

func _on_Timer_timeout():
	self.call_deferred("free")
