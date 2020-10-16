extends Enemy

var vetor
var side
var pos = Vector2()
var t = 0
var M = Transform2D()

##Particle generator variables
var past_position

func _ready():
	raio = 50
	$AudioStreamPlayer2D.stream = die_sfx
	$AnimationPlayer.play("IDLE")
	side = rng.randi_range(0,1)
	match plain:
		1:
			if side == 0:
				pos.x = rng.randf_range(0,resolution.x/2.0)
				pos.y = -10
			else:
				pos.x = -10
				pos.y = rng.randf_range(0,resolution.y/2.0)
		2:
			if side == 0:
				pos.x = rng.randf_range(resolution.x/2.0,resolution.x)
				pos.y = -10
			else:
				pos.x = resolution.x + 10.0
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
		3:
			if side == 0:
				pos.x = rng.randf_range(0,resolution.x/2.0)
				pos.y = resolution.y + 10
			else:
				pos.x = -10
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
		4:
			if side == 0:
				pos.x = rng.randf_range(resolution.x/2.0,resolution.x)
				pos.y = resolution.y + 10
			else:
				pos.x = resolution.x + 10
				pos.y = rng.randf_range(resolution.y/2.0,resolution.y)
	
	
	print(resolution)
	self.position = pos
	
	vetor = (self.position - resolution/2.0).normalized()
	acel = vetor*(-speed)
	var ang = acel.angle()
	print("tg = ",tan(ang))
	M = Transform2D(Vector2(cos(ang),-sin(ang)),Vector2(sin(ang),cos(ang)),self.position)
	print("pos = ",pos)
	print("acel = ",acel)
	print("ang = ",ang)
	print("vetor = ",vetor)
	#Setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)

	
func _physics_process(delta):
	var parametric = Vector2(10.0*t,Raio*sin(t/2))
	self.position.x = M[0].x * parametric.x + M[0].y * parametric.y + M[2].x
	self.position.y = M[1].x * parametric.x + M[1].y * parametric.y + M[2].y
	t+=delta*speed
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2
