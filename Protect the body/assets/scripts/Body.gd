extends KinematicBody2D

export (PackedScene) var canvas_scene
onready var canvas

onready var max_lifes = 3
onready var lifes = max_lifes

signal damage()
signal pointer_on_body()

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.add_to_group("enemy_hit")
		emit_signal("damage")
		var pointer = get_parent().pointer
		pointer.respawn()
		clean(true)

func clean(damage : bool):
	Global.ninja = false
	$Timer.stop()
	for x in get_tree().get_nodes_in_group("trail"):
		x.call_deferred("free")
	
	canvas = canvas_scene.instance()
	canvas.get_node("AnimationPlayer").connect("animation_finished", self, "on_canvas_animation_finished")
	add_child(canvas)
	
	### Dealing with enemy that will die
	var enemies : Array
	
	enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		if damage and enemy.is_in_group("enemy_hit"):
			$CanvasLayer/AnimationPlayer.play("Pulse")
			enemy.die()
		if !damage and enemy.inside_window:
			enemy.die()
		else:
			$CanvasLayer/AnimationPlayer.play("Clean")
			enemy._restart()

# warning-ignore:unused_argument
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

### Deal with enemies inside players' pov
func _on_windowArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.inside_window = true
	
func _on_windowArea_body_exited(body):
	if body.is_in_group("enemy"):
		body.inside_window = false
