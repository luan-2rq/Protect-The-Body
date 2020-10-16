extends Enemy

export(float) var Amp
var vetor
var side
var pos = Vector2()
var t = 0
var M = Transform2D()

##Particle generator variables
var past_position

func _ready():
	M = Transform2D(Vector2(cos(ang),-sin(ang)),Vector2(sin(ang),cos(ang)),self.position)
	##Setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)
	
func _physics_process(delta):
	var parametric = f(t,Amp,10)
	self.position.x = M[0].x * parametric.x + M[0].y * parametric.y + M[2].x
	self.position.y = M[1].x * parametric.x + M[1].y * parametric.y + M[2].y
	t+=delta*speed

func f(t,amp):
	return Vector2(10*t,amp*4.0/10 *(t-10/2.0 * floor(2.0*t/10 + 0.5))*pow(-1,floor(2.0*t/10 + 0.5)))

func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2
