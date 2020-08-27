extends KinematicBody2D

const K = 5                       # número de pétalas da rosácea

export(float) var speed
export(float) var Raio
export(AudioStream) var die_sfx
var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var plain

### Variáveis usadas na movimentação do tipo rosácea
var pos = Vector2()
var amp = 120                     # amplitude da rosácea
var theta = 0                     # ângulo da rosácea
var t = 0                         # variável de interpolação
var d = 2                         # distância entre o centro e a posição da rosácea mais próxima do centro

signal die
##Particle generator variables
var past_position

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	
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
	###Setting particle generator rotation
	set_particle_generator_rotation(self.position)

func set_particle_generator_rotation(body_position, main_movement_direction = null):
	var direction
	if main_movement_direction != null:
		$CPUParticles2D.rotation = atan2(main_movement_direction.y, main_movement_direction.x) + 3*PI/2
	else:
		if past_position != null:
			direction = body_position - past_position
			$CPUParticles2D.rotation = atan2(direction.y, direction.x) + PI/2
		past_position = body_position

func die():
	$AudioStreamPlayer2D.playing = true
	get_parent().get_node("Control").points += 100
	emit_signal("die")

func _on_AudioStreamPlayer2D_finished():
	queue_free()
