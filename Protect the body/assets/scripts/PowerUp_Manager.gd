extends Node2D

export(PackedScene) var powerup1_scene
export(PackedScene) var powerup2_scene
export(PackedScene) var powerup3_scene
export(PackedScene) var powerup4_scene
export(PackedScene) var powerup5_scene

var powerup : int
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _start():
	$Spawn.start()

func _stop():
	$Spawn.stop()

func _end_wave():
	var powerup1 = powerup1_scene.instance()
	var powerup2 = powerup2_scene.instance()
	
	for i in get_children():
		if i.is_in_group("body"):
			i.call_deferred("free")
	
	powerup1.set_name("Grow")
	powerup2.set_name("Restore")
	powerup1._setup("end_wave", Vector2(171, 360))
	powerup2._setup("end_wave", Vector2(854, 360))
	powerup1.connect("collected", get_parent(), "on_PowerUp_collected", [1])
	powerup2.connect("collected", get_parent(), "on_PowerUp_collected", [2])
	
	self.add_child(powerup1)
	self.add_child(powerup2)

func _on_Spawn_timeout():
	var powerup_scene
	
	powerup = rng.randi_range(3, 5)
	match powerup:
		3:
			powerup_scene = powerup3_scene.instance()
			powerup_scene._setup("in_wave", Vector2.ZERO)
		4:
			powerup_scene = powerup4_scene.instance()
			powerup_scene._setup("in_wave", Vector2.ZERO)
		5:
			powerup_scene = powerup5_scene.instance()
			powerup_scene._setup("in_wave", Vector2.ZERO)
	
	powerup_scene.connect("collected", get_parent(), "on_PowerUp_collected", [powerup])
	self.add_child(powerup_scene)
	
	$Spawn.start()
