extends VBoxContainer

onready var points : int = 0

func _update_points(value : int):
	points += value
	$Label.text = str(points)

