extends Enemy

func _ready():
	state = 1
	#setting particle generator rotation
	set_particle_generator_rotation(-vetor.x, -vetor.y)
	
func _physics_process(delta):
	#move_and_slide(40 * acel)
	self.position = self.position + acel
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2
