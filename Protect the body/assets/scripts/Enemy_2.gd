extends Enemy

##Particle generator rotation
var past_position

func _ready():
	raio = 2
	state = 2

func _physics_process(delta):
	#Setting particle generator rotation
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
