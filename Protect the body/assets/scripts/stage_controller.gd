extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy4_scene
export(PackedScene)var powerup1_scene
export(PackedScene)var powerup2_scene
export(PackedScene)var powerup3_scene
var enemy_scene
var powerup_scene

export(PackedScene)var pointer_scene
var pointer
var rng = RandomNumberGenerator.new()
var enemy
var powerup

func _ready():
	$Enemy_spawning.start()
	$PowerUp_spawning.start()
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)

func _on_Enemy_spawning_timeout():
	enemy = rng.randi_range(1,3)
	match enemy:
		1:
			enemy_scene = enemy1_scene.instance()
		2:
			enemy_scene = enemy2_scene.instance()
		3:
			enemy_scene = enemy4_scene.instance()
	add_child(enemy_scene)

func on_Enemy_7_created_enemy(sun):
	add_child(sun)

func _on_PowerUp_spawning_timeout():
	powerup = rng.randi_range(1, 3)
	match powerup:
		1:
			powerup_scene = powerup1_scene.instance()
		2:
			powerup_scene = powerup2_scene.instance()
			powerup_scene.connect("clean", self, "on_PowerUp_clean")
		3:
			powerup_scene = powerup3_scene.instance()
			powerup_scene.connect("restore", self, "on_PowerUp_restore")
	add_child(powerup_scene)

func on_PowerUp_clean():
	get_node("Body").clean()

func on_PowerUp_restore():
	get_node("Body").lifes = get_node("Body").max_lifes
