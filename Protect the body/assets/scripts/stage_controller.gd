extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy4_scene
export(PackedScene)var powerup1_scene
export(PackedScene)var powerup2_scene
export(PackedScene)var powerup3_scene
export(PackedScene)var powerup4_scene
export(PackedScene)var hp_scene
export(PackedScene)var points_scene
export(PackedScene)var poweruptext_scene
export(PackedScene)var combo_scene
var enemy_scene
var powerup_scene

export(PackedScene)var pointer_scene
var pointer
var hp
var rng = RandomNumberGenerator.new()
var enemy
var powerup

func _ready():
	var hp_box = hp_scene.instance()
	var points_box = points_scene.instance()
	var powerup_text = poweruptext_scene.instance()
	var combo = combo_scene.instance()
	
	combo.set_name("Combo")
	combo.rect_position.x = 768
	
	points_box.set_name("Points_Box")
	points_box.rect_position.y = 128
	
	powerup_text.set_name("PowerUp_Text")
	powerup_text.rect_position.y = 192
	
	$Enemy_spawning.start()
	$PowerUp_spawning.start()
	
	hp_box._setup($Body)
	hp_box.rect_position = Vector2(17, 17)
	hp_box.connect("dead", self, "_on_pointer_death")
	
	pointer = pointer_scene.instance()
	get_node("Body").add_child(pointer)
	
	$Body.connect("damage", self, "_on_damage_taken")
	
	self.add_child(hp_box)
	self.add_child(points_box)
	self.add_child(powerup_text)
	self.add_child(combo)

func _on_Enemy_spawning_timeout():
	enemy = rng.randi_range(1,3)
	match enemy:
		1:
			enemy_scene = enemy1_scene.instance()
		2:
			enemy_scene = enemy2_scene.instance()
		3:
			enemy_scene = enemy4_scene.instance()
	enemy_scene.connect("die", self, "on_Enemy_die")
	add_child(enemy_scene)

func on_Enemy_7_created_enemy(sun):
	add_child(sun)

func _on_PowerUp_spawning_timeout():
	powerup = rng.randi_range(1, 4)
	match powerup:
		1:
			powerup_scene = powerup1_scene.instance()
			powerup_scene.connect("speedup", self, "on_PowerUp_speedup")
		2:
			powerup_scene = powerup2_scene.instance()
			powerup_scene.connect("clean", self, "on_PowerUp_clean")
		3:
			powerup_scene = powerup3_scene.instance()
			powerup_scene.connect("restore", self, "on_PowerUp_restore")
		4:
			powerup_scene = powerup4_scene.instance()
			powerup_scene.connect("shield", self, "on_PowerUp_shield")
	add_child(powerup_scene)

func on_PowerUp_clean():
	$Body.clean()
	$PowerUp_Text/Label.text = "CLEAN UP"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")

func on_PowerUp_restore():
	$Body.lifes = $Body.max_lifes
	$PowerUp_Text/Label.text = "RESTORE"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")

func on_PowerUp_speedup():
	Global.velocity_modifier += 0.25
	$PowerUp_Text/Label.text = "SPEED UP"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")

func on_PowerUp_shield(shield_scene : PackedScene):
	if $Shield != null:
		$Shield.call_deferred("free")
	
	var shield = shield_scene.instance()
	shield.set_name("Shield")
	shield.set_position($Body.position)
	self.add_child(shield)
	$PowerUp_Text/Label.text = "SHIELD"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")

func on_Enemy_die():
	$Points_Box._update_points(100 * ($Combo.counter + 1))
	$Combo._update_mult()

func _on_damage_taken():
	$Combo._reset_mult()

func _on_pointer_death():
	get_tree().paused = true
