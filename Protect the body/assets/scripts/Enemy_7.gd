extends Enemy

export (PackedScene) var sun_scene

signal created_enemy(enemy)

var vetor
var side
var pos = Vector2()

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	side = rng.randi_range(0,1)
	match plain:
		1:
			if side == 0:
				pos.x = rng.randf_range(0,resolution.x/2.0)
				pos.y = -20
			else:
				pos.x = -20
				pos.y = rng.randf_range(0,resolution.y/2.0)
		2:
			if side == 0:
				pos.x = rng.randf_range(resolution.x/2.0,resolution.x)
				pos.y = -20
			else:
				pos.x = resolution.x + 20.0
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
		3:
			if side == 0:
				pos.x = rng.randf_range(0,resolution.x/2.0)
				pos.y = resolution.y + 20
			else:
				pos.x = -20
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
		4:
			if side == 0:
				pos.x = rng.randf_range(resolution.x/2.0,resolution.x)
				pos.y = resolution.y + 20
			else:
				pos.x = resolution.x + 20
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
	
	self.position = pos
	vetor = (self.position - resolution/2.0).normalized()
	acel = vetor*(-speed)
	
	#setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)
	
func _physics_process(delta):
	#move_and_slide(40 * acel)
	self.position = self.position + acel
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2

func die():
	$AudioStreamPlayer2D.playing = true

func _on_AudioStreamPlayer2D_finished():
	$CollisionShape2D.queue_free()
	self.visible = false
	var sun1 = sun_scene.instance()
	sun1.setup(self.position + 16*Vector2.ONE, 1)
	emit_signal("created_enemy", sun1)
	var sun2 = sun_scene.instance()
	sun2.setup(self.position - 16*Vector2.ONE, -1)
	emit_signal("created_enemy", sun2)
	call_deferred("free")


func _on_Area2D_mouse_entered():
	if fruit_ninja_power_up:
		self.die()
