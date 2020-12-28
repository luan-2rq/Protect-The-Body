extends Node2D

const maxLength = 512

export var speed : int

onready var pos : float = 0
onready var LeftRight = [$Left, $Right]
onready var UpDown = [$Up, $Down]

func _physics_process(delta):
	pos += speed * delta
	for side in LeftRight:
		side.get_node("Sprite").region_rect.end.x = pos
		side.get_node("Area2D").scale.x = pos / 512
	for side in UpDown:
		side.get_node("Sprite").region_rect.end.y = pos * 360 / 512
		side.get_node("Area2D").scale.y = pos / 360

func _on_Area2D_body_entered(body):
	print("FOI")
