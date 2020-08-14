extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy3_scene
export(PackedScene)var enemy4_scene
export(PackedScene)var enemy5_scene
export(PackedScene)var enemy6_scene
var enemy1
var enemy2
var enemy3
var enemy4
var enemy5
var enemy6
export(PackedScene)var pointer_scene
var pointer

func _ready():
	$Timer.start()
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)
	enemy1 = enemy2_scene.instance()
	enemy2 = enemy2_scene.instance()
	enemy3 = enemy2_scene.instance()
	add_child(enemy1)
	add_child(enemy2)
	add_child(enemy3)
	
func _on_Timer_timeout():
	enemy1 = enemy1_scene.instance()
	enemy2 = enemy1_scene.instance()
	enemy3 = enemy2_scene.instance()
	enemy4 = enemy4_scene.instance()
	enemy5 = enemy5_scene.instance()
	add_child(enemy1)
	add_child(enemy2)
	add_child(enemy3)
	add_child(enemy4)
	add_child(enemy5)
	add_child(enemy6)


