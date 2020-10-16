extends Enemy

export (PackedScene) var sun_scene

signal created_enemy(enemy)


func _ready():
	state = 1
	#setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2

func _on_AudioStreamPlayer2D_finished():
	$CollisionShape2D.queue_free()
	self.visible = false
	var sun1 = sun_scene.instance()
	sun1.setup(self.position + 16*Vector2.ONE, 1)
	emit_signal("created_enemy", sun1)
	var sun2 = sun_scene.instance()
	sun2.setup(self.position - 16*Vector2.ONE, -1)
	emit_signal("created_enemy", sun2)
