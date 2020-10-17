extends KinematicBody2D

export (PackedScene) var canvas_scene
onready var canvas

onready var max_lifes = 3
onready var lifes = max_lifes

signal damage()
signal pointer_on_body()

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("damage")
		var pointer = get_parent().pointer
		pointer.respawn()
		clean(true)

func clean(damage):
	Global.ninja = false
	$Timer.stop()
	for x in get_tree().get_nodes_in_group("trail"):
		x.call_deferred("free")
	
	canvas = canvas_scene.instance()
	canvas.get_node("AnimationPlayer").connect("animation_finished", self, "on_canvas_animation_finished")
	add_child(canvas)
	for enemy in get_tree().get_nodes_in_group("enemy"):
			if damage:
				$CanvasLayer/AnimationPlayer.play("Pulse")
				enemy.call_deferred("free")
			else:
				$CanvasLayer/AnimationPlayer.play("Clean")
				enemy.die()

func on_canvas_animation_finished(AnimName):
	$CanvasLayer.call_deferred("free")

func ninja():
	Global.ninja = true
	$Timer.start()

func _process(_delta):
	if self.has_node("Pointer"):
		emit_signal("pointer_on_body")
	
	#if Global.ninja:
	#	for x in get_tree().get_nodes_in_group("enemy"):
	#		if not x.has_node("Pointer"):
	#			x.set_deferred("fruit_ninja_power_up", true)
	#		else: x.set_deferred("fruit_ninja_power_up", false)
	
func _on_Timer_timeout():
	Global.ninja = false
	for x in get_tree().get_nodes_in_group("trail"):
		x.call_deferred("free")
	for x in get_tree().get_nodes_in_group("enemy"):
		x.set_deferred("fruit_ninja_power_up", false)
