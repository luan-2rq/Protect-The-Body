extends KinematicBody2D

onready var max_lifes = 3
onready var lifes = max_lifes
var fruit_ninja

signal damage()
signal pointer_on_body()

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("damage")
		var pointer = get_parent().pointer
		pointer.respawn()
		clean()

func clean():
	$CanvasLayer/AnimationPlayer.play("Pulse")
	for x in get_tree().get_nodes_in_group("enemy"):
			x.call_deferred("free")
			
func fruit_ninja():
	fruit_ninja = true
	$Timer.start()
	
func _process(delta):
	if self.has_node("Pointer"):
		emit_signal("pointer_on_body")
	
	if fruit_ninja:
		for x in get_tree().get_nodes_in_group("enemy"):
			x.set_deferred("fruit_ninja_power_up", true)
			
func _on_Timer_timeout():
	fruit_ninja = false
	for x in get_tree().get_nodes_in_group("trail"):
		x.queue_free()
