extends Node2D

const maxLength = 512

export var speed : int

onready var LeftRight = [$Left, $Right]
onready var UpDown = [$Up, $Down]

func _physics_process(delta):
	for side in LeftRight:
		side.get_node("RayCast2D").cast_to += Vector2(1, 0)* delta * speed
		side.get_node("Sprite").region_rect.end.x = side.get_node("RayCast2D").cast_to.x
		side.get_node("Area2D").scale.x = side.get_node("RayCast2D").cast_to.x / 512
	for side in UpDown:
		side.get_node("RayCast2D").cast_to += Vector2(0, 1)* delta * speed * 360 / 512 
		side.get_node("Sprite").region_rect.end.y = side.get_node("RayCast2D").cast_to.y
		side.get_node("Area2D").scale.y = side.get_node("RayCast2D").cast_to.y / 360

func _on_Area2D_body_entered(body):
	print("FOI")
