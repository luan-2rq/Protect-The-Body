extends Node2D

class_name Wave

export(PackedScene) var wave_change_scene

export(PackedScene) var enemy1_scene
export(PackedScene) var enemy2_scene
export(PackedScene) var enemy3_scene
export(PackedScene) var enemy4_scene
export(PackedScene) var enemy5_scene
export(PackedScene) var enemy6_scene
export(PackedScene) var enemy7_scene

var enemy1_num  : int = 2
var enemy2_num  : int = 2
var enemy3_num  : int 
var enemy4_num  : int = 2
var enemy5_num  : int
var enemy6_num  : int
var enemy7_num  : int

var enemy1_init : int = enemy1_num
var enemy2_init : int = enemy2_num
var enemy3_init : int = enemy3_num
var enemy4_init : int = enemy4_num
var enemy5_init : int = enemy5_num
var enemy6_init : int = enemy6_num
var enemy7_init : int = enemy7_num

var total_enem : int
var total_dead : int

var enemy1_dead : int
var enemy2_dead : int
var enemy3_dead : int
var enemy4_dead : int
var enemy5_dead : int
var enemy6_dead : int
var enemy7_dead : int

var wave_num  : String

var end : bool = false

signal wave_end

func _get_enemies() -> Array:
	return [enemy1_init, enemy2_init, enemy3_init, enemy4_init, enemy5_init, enemy6_init, enemy7_init]

func _process(_delta):
	var enemiesPercentage = (float(total_dead)/total_enem)*100
	
	$ProgressBar.value = enemiesPercentage
	
	if (total_enem == total_dead) and not end:
		emit_signal("wave_end")
		end = true

func _update():
	total_dead += 1

func _change(wave_number : int):
	var wave_change = wave_change_scene.instance()
	
	wave_change.set_name("Change")
	wave_change.connect("start", self, "_start")
	wave_change.get_node("Box").get_node("Wave_Title").text = "wave " + str(wave_number)
	
	self.add_child(wave_change)
	
	$Change.get_node("Timer").start()

func _on_Enemy1_spawn_timeout():
	if enemy1_num > 0:
		var enemy_scene = enemy1_scene.instance()
		enemy_scene.connect("die", get_parent(), "on_Enemy_die")
		
		self.get_parent().add_child(enemy_scene)
		
		enemy1_num -= 1
		
		$Enemy1_spawn.start()

func _on_Enemy2_spawn_timeout():
	if enemy2_num > 0:
		var enemy_scene = enemy2_scene.instance()
		enemy_scene.connect("die", get_parent(), "on_Enemy_die")
		
		self.get_parent().add_child(enemy_scene)
		
		enemy2_num -= 1
		
		$Enemy2_spawn.start()

func _on_Enemy3_spawn_timeout():
	if enemy3_num > 0:
		var enemy_scene = enemy3_scene.instance()
		enemy_scene.connect("die", get_parent(), "on_Enemy_die")
		
		self.get_parent().add_child(enemy_scene)
		
		enemy3_num -= 1
		
		$Enemy3_spawn.start()

func _on_Enemy4_spawn_timeout():
	if enemy4_num > 0:
		var enemy_scene = enemy4_scene.instance()
		enemy_scene.connect("die", get_parent(), "on_Enemy_die")
		
		self.get_parent().add_child(enemy_scene)
		
		enemy4_num -= 1
		
		$Enemy4_spawn.start()
