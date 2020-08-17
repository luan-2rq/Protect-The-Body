extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy4_scene
var enemy1
var enemy2
var enemy4

export(PackedScene)var pointer_scene
var pointer
signal respawn
var rng = RandomNumberGenerator.new()
var enemy

func _ready():
	$Timer.start()
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)
	
func _on_Timer_timeout():
	enemy = rng.randi_range(1,3)
	match enemy:
		1:
			enemy1 = enemy1_scene.instance()
			add_child(enemy1)
		2:
			enemy2 = enemy2_scene.instance()
			add_child(enemy2)
		3:
			enemy4 = enemy4_scene.instance()
			add_child(enemy4)

func _on_Area2D_body_entered(body):
	if body.is_in_group("pointer"):
		emit_signal("respawn")
