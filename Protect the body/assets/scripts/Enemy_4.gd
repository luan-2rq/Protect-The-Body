extends KinematicBody2D

const K = 5                       # número de pétalas da rosácea

export(float) var speed
export(float) var Raio
var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var plain

### Variáveis usadas na movimentação do tipo rosácea
var pos = Vector2()
var amp = 120                     # amplitude da rosácea
var theta = 0                     # ângulo da rosácea
var t = 0                         # variável de interpolação
var d = 2                         # distância entre o centro e a posição da rosácea mais próxima do centro

func _ready():
	rng.seed = 300
	rng.randomize()
	
	plain = rng.randi_range(1,4)
	match plain:
		1:
			pos.x = 0
			pos.y = 0
			theta = PI / 4
		2:
			pos.x = resolution.x
			pos.y = 0
			theta = 3*PI / 4
		3:
			pos.x = 0
			pos.y = resolution.y
			theta = 7*PI / 4
		4:
			pos.x = resolution.x
			pos.y = resolution.y
			theta = 5*PI / 4
	
	self.position = pos

func _physics_process(delta):
	var CENTRO = Vector2(resolution.x / 2, resolution.y / 2)
	var rose_function = Vector2(amp*(sin(K*theta)*cos(theta) + d*cos(theta)), (amp*(sin(K*theta)*sin(theta) + d*sin(theta))))
	
	t += 0.01 * delta
	theta += 0.3 * delta
	
	if amp >= 0:
		amp -= 1 * delta
	
	self.position = self.position.linear_interpolate(Vector2(CENTRO.x - rose_function.x, CENTRO.y - rose_function.y), t)
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2
