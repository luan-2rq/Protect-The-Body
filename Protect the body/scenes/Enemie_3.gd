
extends KinematicBody2D


export(float) var speed
export(float) var Raio
var vetor = Vector2()
var acel = Vector2()
var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var side
var plain
var pos = Vector2()
var t = 0
var perp
var M 

func _ready():
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
	perp = Vector2(-acel.y,acel.x)
	M = Transform2D(acel,perp,pos)
	
	
func _physics_process(delta):
	var aux = Vector2(t,Raio*sin(t))
	self.position.x += M[0].dot(aux)
	self.position.y += M[1].dot(aux)
	#self.position.y += t*acel.y
	t+=delta



