extends Node2D

export(PackedScene)var enemie1_scene
export(PackedScene)var enemie2_scene
var enemie1
var enemie2
var enemie3

export(PackedScene)var pointer_scene
var pointer

func _ready():
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)
	
	enemie1 = enemie1_scene.instance()
	enemie2 = enemie1_scene.instance()
	enemie3 = enemie2_scene.instance()
	add_child(enemie1)
	add_child(enemie2)
	add_child(enemie3)
	
	
