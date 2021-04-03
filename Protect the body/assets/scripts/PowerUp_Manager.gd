extends Node2D

export(PackedScene) var powerup_scene

var powerup_num : int
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _start():
	$Spawn.start()

func _stop():
	$Spawn.stop()

func _end_wave():
	var powerup1 = powerup_scene.instance()
	var powerup2 = powerup_scene.instance()
	
	for i in get_children():
		if i.is_in_group("body"):
			i.call_deferred("free")
	
	powerup1.set_name("Grow")
	powerup2.set_name("Restore")
	powerup1._setup("end_wave", Vector2(171, 360), 0)
	powerup2._setup("end_wave", Vector2(854, 360), 1)
	powerup1.connect("collected", get_parent(), "on_PowerUp_collected", [0])
	powerup2.connect("collected", get_parent(), "on_PowerUp_collected", [1])
	
	self.add_child(powerup1)
	self.add_child(powerup2)

func _on_Spawn_timeout():
	var powerup
	
	powerup_num = rng.randi_range(2, 4)
	powerup = powerup_scene.instance()
	powerup._setup("in_wave", Vector2.ZERO, powerup_num)
	
	powerup.connect("collected", get_parent(), "on_PowerUp_collected", [powerup_num])
	self.add_child(powerup)
	
	$Spawn.start()
