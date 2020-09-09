extends Line2D

var point
export(int)var trail_size


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	point = get_viewport().get_mouse_position()
	add_point(point)
	if get_point_count() > trail_size:
		remove_point(0)
	
