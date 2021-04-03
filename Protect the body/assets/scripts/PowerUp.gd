extends KinematicBody2D
class_name PowerUp

var sprite_red = preload("res://assets/sprites/PowerUpGrowUp.png")
var sprite_green = preload("res://assets/sprites/PowerUpRegen.png")
var sprite_blue = preload("res://assets/sprites/PowerUpShield.png")
var sprite_yellow = preload("res://assets/sprites/PowerUpNinja.png")
var sprite_purple = preload("res://assets/sprites/PowerUpClean.png")
var setup_color
var rng = RandomNumberGenerator.new()
var plain : int
var pos : Vector2
var resolution : Vector2 = OS.get_window_size()
onready var colors : Array = [Color8(214, 4, 4), Color8(85, 227, 68), Color8(123, 107, 255), Color8(241, 233, 85), Color8(152, 51, 136)]
onready var sprite_main : Sprite = $Sprite
onready var sprite_circle : Sprite = $Circle
onready var particles : Particles2D = $Particles2D

signal collected

func _setup(state : String, func_pos : Vector2, color : int):
	if state == "end_wave":
		pos = func_pos
	else:
		$Timer.connect("timeout", self, "on_Timer_timeout")
		$Timer.autostart = true
		
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
	
	setup_color = color

func _ready():
	sprite_circle.modulate = colors[setup_color]
	particles.modulate = colors[setup_color]
	match setup_color:
		0:
			sprite_main.set_texture(sprite_red)
		1:
			sprite_main.set_texture(sprite_green)
		2:
			sprite_main.set_texture(sprite_blue)
		3:
			sprite_main.set_texture(sprite_yellow)
		4:
			sprite_main.set_texture(sprite_purple)
#	$Timer.connect("timeout", self, "on_Timer_timeout")
#	$Timer.start()
	
	$Tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()
	
	$AnimationPlayer.play("powerup_anim")
	
#	rng.randomize()
#
#	plain = rng.randi_range(1, 4)
#	match plain:
#		1:
#			pos.x = rng.randf_range(20, resolution.x/2.0 -100)
#			pos.y = rng.randf_range(20, resolution.y/2.0 +100)
#		2:
#			pos.x = rng.randf_range(resolution.x/2.0 +100, resolution.x -20)
#			pos.y = rng.randf_range(20, resolution.y/2.0 - 100)
#		3:
#			pos.x = rng.randf_range(20, resolution.x/2.0 -100)
#			pos.y = rng.randf_range(resolution.y/2.0 +100, resolution.y -20)
#		4:
#			pos.x = rng.randf_range(resolution.x/2.0 +100, resolution.x -20)
#			pos.y = rng.randf_range(resolution.y/2.0 +100, resolution.y -20)
#
#	self.position = pos

func on_Timer_timeout():
	if not self.has_node("Pointer"):
		call_deferred("free")
	else: 
		$Timer.wait_time = 0.1
		$Timer.start()

func die():
	emit_signal("collected")
	call_deferred("free")
