extends VBoxContainer

var sprites : Array = []
var organ : KinematicBody2D
var hp : int
var level : int = 0
var path : String = ""

signal dead()

func _setup(body : KinematicBody2D):
	organ = body
	# warning-ignore:return_value_discarded
	organ.connect("damage", self, "_on_damage")
	hp = organ.max_lifes
	
	path = "res://assets/HUD/Sprites/Level" + str(level) + ".png"
	
	for i in range(hp):
		var hp_sprite = Sprite.new()
		hp_sprite.texture = load(path)
		hp_sprite.position.x = i * 34
		self.add_child(hp_sprite)

func _process(_delta):
	if hp == 0:
		emit_signal("dead")

func _next_level() -> void:
	level += 1

func _on_damage():
	if hp > 0:
		get_child(hp - 1).queue_free()
		hp -= 1
