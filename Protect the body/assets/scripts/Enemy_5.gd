extends Enemy

const SPEED = 200
const R = 3               # Raio da espiral

export(float) var Raio

### Variáveis para a movimentação
var M = Transform2D()
var theta
var pos = Vector2()
var mov = Vector2()

### Particle generator variables
var past_position

func _ready():
	rng.seed = 300
	rng.randomize()
	
	plain = rng.randi_range(1,4)
	match plain:
		1:
			pos.x = -20
			pos.y = -20
		2:
			pos.x = resolution.x + 20
			pos.y = -20
		3:
			pos.x = -20
			pos.y = resolution.y + 20
		4:
			pos.x = resolution.x + 20
			pos.y = resolution.y + 20
	
	theta = 0
	self.position = pos
	mov = Vector2((resolution.x / 2) - pos.x, (resolution.y / 2) - pos.y).normalized()
	M.y.x = mov.x * SPEED
	M.y.y = mov.y * SPEED
	
func _physics_process(delta):
	match plain:
		1:
			M.y.x -= 3000 * pow(delta, 2)
		2:
			M.y.y -= 2100 * pow(delta, 2)
		3:
			M.y.y += 2100 * pow(delta, 2)
		4:
			M.y.x += 3000 * pow(delta, 2)
	theta += 0.1
	M.x.x = R*cos(theta) + M.y.x*delta
	M.x.y = R*sin(theta) + M.y.y*delta 
	self.position += M[0]
	#Setting particle generator rotation
	set_particle_generator_rotation(self.position, M.y)

func set_particle_generator_rotation(body_position, main_movement_direction = null):
	var direction
	if main_movement_direction != null:
		$CPUParticles2D.rotation = atan2(main_movement_direction.y, main_movement_direction.x) + PI/2
	else:
		if past_position != null:
			direction = body_position - past_position
			$CPUParticles2D.rotation = atan2(direction.y, direction.x) + PI/2
		past_position = body_position

func die():
	queue_free()


func _on_AudioStreamPlayer2D_finished():
	pass # Replace with function body.


func _on_Area2D_mouse_entered():
	if fruit_ninja_power_up:
		self.die()
