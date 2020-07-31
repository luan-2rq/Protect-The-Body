extends KinematicBody2D

export(int)var circle_rotation_speed
var circle_rotation_direction = 0
var last_shoot_circle_rotation

export(PackedScene)var pointer_scene
var pointer
export(int)var pointer_shoot_speed
var pointer_allowed_to_turn
var last_shoot_pointer_position
var last_shoot_pointer_rotation
var move_pointer = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pointer = pointer_scene.instance()
	self.add_child(pointer)

func get_input():
	if Input.is_action_pressed('ui_right'):
		circle_rotation_direction = -1
	if Input.is_action_pressed('ui_left'):
		circle_rotation_direction = 1
	if Input.is_action_just_released(('ui_right')):
		circle_rotation_direction = 0
	if Input.is_action_just_released(('ui_left')):
		circle_rotation_direction = 0
	if Input.is_action_just_pressed("ui_accept"):
		call_deferred("shoot")
	if Input.is_action_just_pressed('shift'):
		respawn_pointer()
		
func _physics_process(delta):
	get_input()
	global_rotation += circle_rotation_speed * circle_rotation_direction * delta

	if move_pointer:
		pointer.move_and_slide(Vector2(0, -pointer_shoot_speed).rotated(pointer.global_rotation))
		
	if pointer.get_child(0).is_colliding():
		if !pointer.get_child(0).get_collider().is_in_group("body"):
			pointer_allowed_to_turn = true

	if pointer.get_child(0).is_colliding():
		if pointer.get_child(0).get_collider().is_in_group("body"):
			respawn_pointer()

	if pointer_allowed_to_turn:
		pointer.global_rotation += PI
		pointer_allowed_to_turn = false
		
func shoot():
	last_shoot_pointer_position = pointer.global_position
	last_shoot_pointer_rotation = pointer.global_rotation
	
	last_shoot_circle_rotation = self.global_rotation
	
	remove_child(pointer)
	get_parent().add_child(pointer)

	pointer.global_position = last_shoot_pointer_position
	pointer.global_rotation = last_shoot_pointer_rotation
	move_pointer = true
		

func respawn_pointer():
	move_pointer = false
	
	get_parent().remove_child(pointer)
	self.add_child(pointer)
	
	global_rotation = last_shoot_circle_rotation
	
	pointer.global_rotation = last_shoot_pointer_rotation
	pointer.global_position = last_shoot_pointer_position
