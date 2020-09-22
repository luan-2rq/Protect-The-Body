extends Node2D

export(PackedScene)var enemy1_scene
export(PackedScene)var enemy2_scene
export(PackedScene)var enemy4_scene
export(PackedScene)var powerup1_scene
export(PackedScene)var powerup2_scene
export(PackedScene)var powerup3_scene
export(PackedScene)var powerup4_scene
export(PackedScene)var shield_scene
export(PackedScene)var powerup5_scene
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

export(PackedScene)var fruit_ninja_trail_scene

func _ready():
	var hp_box = hp_scene.instance()
	var points_box = points_scene.instance()
	var powerup_text = poweruptext_scene.instance()
	var combo = combo_scene.instance()
	
	combo.set_name("Combo")
	combo.rect_position.x = 400
	
	points_box.set_name("Points_Box")
	points_box.rect_position.y = 128
	
	powerup_text.set_name("PowerUp_Text")
	powerup_text.rect_position.y = 192
	
	$Enemy_spawning.start()
	$PowerUp_spawning.start()
	
	hp_box.set_name("HP")
	hp_box._setup($Body)
	hp_box.rect_position = Vector2(22, 22)
	hp_box.connect("dead", self, "_on_pointer_death")
	
	pointer = pointer_scene.instance()
	pointer.set_name("Pointer")
	get_node("Body").add_child(pointer)
	
	# warning-ignore:return_value_discarded
	$Body.connect("damage", self, "_on_damage_taken")
	# warning-ignore:return_value_discarded
	$Body.connect("pointer_on_body", self, "_pointer_on_body")
	
	self.add_child(hp_box)
	self.add_child(points_box)
	self.add_child(powerup_text)
	self.add_child(combo)
	
	get_tree().paused = false
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1, 1), 1)
	$Tween.start()

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
	
	$Enemy_spawning.wait_time -= 0.02

func on_Enemy_7_created_enemy(sun):
	add_child(sun)

func _on_PowerUp_spawning_timeout():
	powerup = rng.randi_range(1,5)
	match powerup:
		1:
			powerup_scene = powerup1_scene.instance()
		2:
			powerup_scene = powerup2_scene.instance()
		3:
			powerup_scene = powerup3_scene.instance()
		4:
			powerup_scene = powerup4_scene.instance()
		5:
			powerup_scene = powerup5_scene.instance()
	powerup_scene.connect("collected", self, "on_PowerUp_collected")
	add_child(powerup_scene)

func on_PowerUp_collected():
	match powerup:
		1:
			pointer.scale += Vector2(0.2, 0.2)
			$PowerUp_Text/Label.text = "GROW UP"
		2:
			$Body.clean(false)
			$PowerUp_Text/Label.text = "CLEAN UP"
		3:
			$Body.lifes = $Body.max_lifes
			$HP._setup($Body)
			$PowerUp_Text/Label.text = "RESTORE"
		4:
			if self.has_node("Shield"):
				$Shield.call_deferred("free")
			var shield = shield_scene.instance()
			shield.set_name("Shield")
			shield.set_position($Body.position)
			self.add_child(shield)
			$PowerUp_Text/Label.text = "SHIELD"
		5:
			add_child(fruit_ninja_trail_scene.instance())
			$Body.fruit_ninja()
			$PowerUp_Text/Label.text = "FRUIT NINJA"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")

func on_Enemy_die():
	$Points_Box._update_points(100 * ($Combo.counter + 1))
	$Combo._update_mult()

func _on_damage_taken():
	$Combo._reset_mult()

func _pointer_on_body():
	$Combo._reset_mult()

func _on_pointer_death():
	get_tree().paused = true

