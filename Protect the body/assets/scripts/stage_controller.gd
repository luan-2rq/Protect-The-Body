extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy4_scene
export(PackedScene)var enemy7_scene
var enemy1
var enemy2
var enemy4
var enemy7

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
	enemy = rng.randi_range(1,4)
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
		4:
			enemy7 = enemy7_scene.instance()
			add_child(enemy7)
			enemy7.connect("created_enemy", self, "on_Enemy_7_created_enemy")

func _on_Area2D_body_entered(body):
	if body.is_in_group("pointer"):
		emit_signal("respawn")

func on_Enemy_7_created_enemy(sun):
	add_child(sun)
