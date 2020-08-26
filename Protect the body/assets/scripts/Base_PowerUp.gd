extends KinematicBody2D
class_name PowerUp

var rng = RandomNumberGenerator.new()
var plain : int
var pos : Vector2
onready var resolution : Vector2 = OS.get_window_size()

func _ready():
	$Timer.connect("timeout", self, "on_Timer_timeout")
	$Timer.start()
	
	$AnimationPlayer.play("Rotate")
	
	rng.randomize()
	
	plain = rng.randi_range(1, 4)
	match plain:
		1:
			pos.x = rng.randf_range(20, resolution.x/2.0 -100)
			pos.y = rng.randf_range(20, resolution.y/2.0 +100)
		2:
			pos.x = rng.randf_range(resolution.x/2.0 +100, resolution.x -20)
			pos.y = rng.randf_range(20, resolution.y/2.0 - 100)
		3:
			pos.x = rng.randf_range(20, resolution.x/2.0 -100)
			pos.y = rng.randf_range(resolution.y/2.0 +100, resolution.y -20)
		4:
			pos.x = rng.randf_range(resolution.x/2.0 +100, resolution.x -20)
			pos.y = rng.randf_range(resolution.y/2.0 +100, resolution.y -20)
	
	self.position = pos

func on_Timer_timeout():
	call_deferred("free")
