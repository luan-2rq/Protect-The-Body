extends Node2D

export(PackedScene)var enemie1_scene
export(PackedScene)var enemie2_scene
export(PackedScene)var enemie3_scene
export(PackedScene)var enemie5_scene
export(PackedScene)var enemie6_scene
var enemie1
var enemie2
var enemie3
var enemie4
var enemie5

export(PackedScene)var pointer_scene
var pointer

func _ready():
	$Timer.start()
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)
	enemie1 = enemie2_scene.instance()
	enemie2 = enemie2_scene.instance()
	enemie3 = enemie2_scene.instance()
	add_child(enemie1)
	#add_child(enemie2)
	add_child(enemie3)

func _on_Timer_timeout():
	enemie1 = enemie1_scene.instance()
	enemie2 = enemie1_scene.instance()
	enemie3 = enemie2_scene.instance()
	enemie4 = enemie5_scene.instance()
	enemie5 = enemie6_scene.instance()
	#add_child(enemie1)
	add_child(enemie2)
	#add_child(enemie3)
	add_child(enemie4)
	#add_child(enemie5)
