extends Wave

const maxLength = 512

export var speed : int

onready var pos : float = 0
onready var LeftRight = [$Left, $Right]
onready var UpDown = [$Up, $Down]

func _ready():
	$Enemy1_spawn.connect("timeout", self, "_on_Enemy1_spawn_timeout")
	$Enemy2_spawn.connect("timeout", self, "_on_Enemy2_spawn_timeout")
	$Enemy4_spawn.connect("timeout", self, "_on_Enemy4_spawn_timeout")
	self._change(4)
	total_enem = enemy1_init + enemy2_init + enemy4_init
	
	self.get_parent().get_node("HP").raise()
	self.get_parent().get_node("Combo").raise()

func _physics_process(delta):
	pos += speed * delta
	for side in LeftRight:
		side.get_node("Sprite").region_rect.end.x = pos
		side.get_node("Area2D").scale.x = pos / 512
	for side in UpDown:
		side.get_node("Sprite").region_rect.end.y = pos * 360 / 512
		side.get_node("Area2D").scale.y = pos / 512

func _on_Area2D_body_entered(body):
	print("FOI")

func _start():
	$Change.call_deferred("free")
	$Enemy1_spawn.start()
	$Enemy2_spawn.start()
	$Enemy4_spawn.start()
