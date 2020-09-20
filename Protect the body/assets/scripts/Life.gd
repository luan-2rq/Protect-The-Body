extends VBoxContainer

export(PackedScene) var heart_scene

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
	
	for i in self.get_children():
		i.call_deferred("free")
	
	for i in range(hp):
		var hp_sprite = heart_scene.instance()
		var node_name = "Heart" + str(i)
		var node_anim
		hp_sprite.set_name(node_name)
		hp_sprite.position.x = i * 40
		
		self.add_child(hp_sprite)
		
		node_anim = self.get_node(node_name + "/AnimationPlayer")
		node_anim.play("Heart_Animation")

func _process(_delta):
	if hp == 0:
		emit_signal("dead")

func _next_level() -> void:
	level += 1

func _on_damage():
	if hp > 0:
		get_child(hp - 1).queue_free()
		hp -= 1
