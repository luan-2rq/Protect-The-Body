extends KinematicBody2D

export(AudioStream) var die_sfx
export (int) var speed
onready var vetor
var acel
var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var side
var y
onready var pos = Vector2.ZERO

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	
	acel = vetor*(-speed)
	
	#setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)
	
func _physics_process(delta):
	#move_and_slide(40 * acel)
	self.position = self.position + acel
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2

func setup(pos, coord):
	rng.seed = 300
	rng.randomize()
	side = rng.randi_range(0, 2)
	self.position = pos
	y = coord
	if side == 1:
		vetor = Vector2(1, y)
	else:
		vetor = Vector2(-1, y)

func die():
	$AudioStreamPlayer2D.playing = true

func _on_AudioStreamPlayer2D_finished():
	queue_free()
