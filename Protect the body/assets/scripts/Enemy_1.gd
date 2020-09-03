extends KinematicBody2D

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

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	
	rng.seed = 300
	rng.randomize()
	$AnimationPlayer.play("IDLE")
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
	
	#setting particle generator rotation
	set_particle_generator_rotation(vetor.x, vetor.y)
	
func _physics_process(delta):
	#move_and_slide(40 * acel)
	self.position = self.position + acel
	
func set_particle_generator_rotation(direction_x, direction_y):
	$CPUParticles2D.rotation = atan2(direction_y, direction_x) + 3 * PI/2

func die():
	$AudioStreamPlayer2D.playing = true
	#get_parent().get_node("Control").points += 100
	var s = preload("res://assets/HUD/Points/Point animation.tscn").instance()
	add_child(s)
	s.get_node("AnimationPlayer").play("IDLE")
	emit_signal("die")

func _on_AudioStreamPlayer2D_finished():
	queue_free()
