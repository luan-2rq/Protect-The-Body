extends Node2D

export(PackedScene)var wave1_scene
export(PackedScene)var powerups_scene

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

var waves       : Array = []
var waves_name  : Array = []
var change_wave : bool  = false

export(PackedScene)var fruit_ninja_trail_scene

func _ready():
	### Instancing scenes
	var hp_box = hp_scene.instance()
	var points_box = points_scene.instance()
	var powerup_text = poweruptext_scene.instance()
	var combo = combo_scene.instance()
	var powerups_manager = powerups_scene.instance()
	var cur_wave
	
	### Variables to open directory
	var path        : String    = ""
	var dir         : Directory = Directory.new()
	var total_waves : int       = 0
	
	### Get waves' scenes
	path = "res://assets/scenes/Waves/"
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name : String = dir.get_next()
		while file_name != "":
			total_waves += 1
			waves.append(path + file_name)
			waves_name.append(file_name.rstrip(".tscn"))
			file_name = dir.get_next()
	else:
		print("Error opening Waves folder")
	
	dir.list_dir_end()
	
	### Setting up instanced scenes
	cur_wave = load(waves[0]).instance()
	cur_wave.connect("wave_end", self, "_on_wave_end")
	
	powerups_manager.set_name("Pup_manager")
	
	combo.set_name("Combo")
	combo.rect_position.x = 400
	
	points_box.set_name("Points_Box")
	points_box.rect_position.y = 128
	
	powerup_text.set_name("PowerUp_Text")
	powerup_text.rect_position.y = 192
	
	#$Enemy_spawning.start()
#	$PowerUp_spawning.start()
	
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
	self.add_child(powerups_manager)
	self.add_child(cur_wave)
	
	waves.pop_front()
	
	get_tree().paused = false
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1, 1), 1)
	$Tween.start()
	
	$Pup_manager._start()
	
	$Body/AnimatedSprite.play()

#func _on_Enemy_spawning_timeout():
#	enemy = rng.randi_range(1,3)
#	match enemy:
#		1:
#			enemy_scene = enemy1_scene.instance()
#		2:
#			enemy_scene = enemy2_scene.instance()
#		3:
#			enemy_scene = enemy4_scene.instance()
#	enemy_scene.connect("die", self, "on_Enemy_die")
#	add_child(enemy_scene)
#
#	$Enemy_spawning.wait_time -= 0.02

func on_Enemy_7_created_enemy(sun):
	add_child(sun)

#func _on_PowerUp_spawning_timeout():
#	powerup = rng.randi_range(3, 5)
#	match powerup:
#		1:
#			powerup_scene = powerup1_scene.instance()
#		2:
#			powerup_scene = powerup2_scene.instance()
#		3:
#			powerup_scene = powerup3_scene.instance()
#			powerup_scene._setup("in_wave", Vector2.ZERO)
#		4:
#			powerup_scene = powerup4_scene.instance()
#			powerup_scene._setup("in_wave", Vector2.ZERO)
#		5:
#			powerup_scene = powerup5_scene.instance()
#			powerup_scene._setup("in_wave", Vector2.ZERO)
#	powerup_scene.connect("collected", self, "on_PowerUp_collected")
#	add_child(powerup_scene)

func on_PowerUp_collected(powerup):
	match powerup:
		1:
			pointer.get_node("Pointer").scale += Vector2(0.2, 0.2)
			pointer.get_node("Pointer").position.y -= 16
			$PowerUp_Text/Label.text = "GROW UP"
		2:
			$Body.lifes = $Body.max_lifes
			$HP._setup($Body)
			$PowerUp_Text/Label.text = "RESTORE"
		3:
			$Body.clean(false)
			$PowerUp_Text/Label.text = "CLEAN UP"
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
			$Body.ninja()
			$PowerUp_Text/Label.text = "NINJA"
	$PowerUp_Text/AnimationPlayer.play("show_powerup")
	
	for i in $Pup_manager.get_children():
		if i.is_in_group("powerupend"):
			i.call_deferred("free")
			
			if change_wave:
				get_node(waves_name[0]).call_deferred("free")
				
				var cur_wave = load(waves[0]).instance()
				
				cur_wave.connect("wave_end", self, "_on_wave_end")
				
				self.add_child(cur_wave)
				
				waves.pop_front()
				waves_name.pop_front()
				
				change_wave = false
				
				$Pup_manager._start()

func on_Enemy_die():
	$Points_Box._update_points(100 * ($Combo.counter + 1))
	$Combo._update_mult()
	get_node(waves_name[0])._update()

func _on_damage_taken():
	$HP._on_damage()
	$Combo._reset_mult()

func _pointer_on_body():
	$Combo._reset_mult()

func _on_pointer_death():
	get_tree().paused = true

func _on_wave_end():
	$Pup_manager._stop()
	$Pup_manager._end_wave()
	
	change_wave = true
