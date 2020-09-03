extends KinematicBody2D

var t = 0
export(float) var speed
export(float) var Raio
export(AudioStream) var die_sfx
var vetor
var acel
var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var side
var plain
var pos = Vector2()
signal die

##Particle generator rotation
var past_position

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	$AnimationPlayer.play("IDLE")
	rng.seed = 300
	rng.randomize()
	
	plain = rng.randi_range(1,4)
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

func _physics_process(delta):
	self.position.x += Raio*cos(t) + acel.x
	self.position.y += Raio*sin(t) + acel.y
	t = t + delta*speed
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

func die():
	$AudioStreamPlayer2D.playing = true
	#get_parent().get_node("Control").points += 100
	emit_signal("die")


func _on_AudioStreamPlayer2D_finished():
	queue_free()
