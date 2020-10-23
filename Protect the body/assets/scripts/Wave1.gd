extends Wave

func _ready():
	var wave_change = wave_change_scene.instance()
	
	wave_num = "wave 1"
	
	wave_change.set_name("Change")
	wave_change.connect("start", self, "_start")
	wave_change.get_node("Box").get_node("Wave_Title").text = wave_num
	
	self.add_child(wave_change)
	
	$Change.get_node("Timer").start()

func _process(_delta):
	if (enemy1_init == enemy1_dead) and not end:
		emit_signal("wave_end")
		end = true

func _start():
	$Change.call_deferred("free")
	$Enemy1_spawn.start()

func _update(dead : bool):
	if dead:
		enemy1_dead += 1

func _on_Enemy1_spawn_timeout():
	if enemy1_num > 0:
		var enemy_scene = enemy1_scene.instance()
		enemy_scene.connect("die", get_parent(), "on_Enemy_die")
		
		self.get_parent().add_child(enemy_scene)
		
		enemy1_num -= 1
		
		$Enemy1_spawn.start()
