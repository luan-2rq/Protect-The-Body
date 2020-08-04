extends KinematicBody2D


var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	if Input.is_action_pressed('ui_right') && enabled:
		body_rotation_direction = -1
	if Input.is_action_pressed('ui_left') && enabled:
		body_rotation_direction = 1
	if Input.is_action_just_released(('ui_right')) && enabled:
		body_rotation_direction = 0
	if Input.is_action_just_released(('ui_left')) && enabled:
		body_rotation_direction = 0
		
func _physics_process(delta):
	get_input()
	global_rotation += body_rotation_speed * body_rotation_direction * delta
