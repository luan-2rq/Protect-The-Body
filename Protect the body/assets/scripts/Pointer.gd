extends Node2D

var main_body
var current_body
var move = false
var raycast_enabled = false
export(int)var shoot_speed
export(int)var rotation_speed
var rotation_direction = 0
var pointer
var able_to_rotate = true

func get_input():
	if Input.is_action_pressed('ui_right') && able_to_rotate:
		rotation_direction = -1
	if Input.is_action_pressed('ui_left') && able_to_rotate:
		rotation_direction = 1
	if Input.is_action_just_released(('ui_right')):
		rotation_direction = 0
	if Input.is_action_just_released(('ui_left')):
		rotation_direction = 0
	if Input.is_action_just_pressed("ui_accept"):
		call_deferred("shoot")
	if Input.is_action_pressed('shift'):
		call_deferred("respawn")

func _ready():
	main_body = get_parent()
	current_body = main_body

func _physics_process(delta):
	get_input()
	global_rotation += rotation_speed * rotation_direction * delta
	if move:
		$Pointer.move_and_slide(Vector2(0, -shoot_speed).rotated(self.global_rotation))
	if $Pointer.get_node("RayCast2D").is_colliding() && raycast_enabled:
		if $Pointer.get_node("RayCast2D").get_collider().is_in_group("body"):
			able_to_rotate = true
			raycast_enabled = false
			move = false
			main_body.get_node("/root").remove_child(self)
			current_body = $Pointer.get_node("RayCast2D").get_collider()
			current_body.add_child(self)
			position =  Vector2(0, 0)
			var local_hit_position = current_body.to_local($Pointer.get_node("RayCast2D").get_collision_point())
			$Pointer.position = Vector2(0, -current_body.get_node("CollisionShape2D").shape.radius * current_body.scale.y) * 12.3
			rotation = atan2(local_hit_position.y, local_hit_position.x) + PI/2
			
func shoot():
	var shoot_position = global_position
	var shoot_rotation = global_rotation
	able_to_rotate = false
	raycast_enabled = true
	current_body.remove_child(self)
	main_body.get_node("/root").add_child(self)
	global_position = shoot_position
	global_rotation = shoot_rotation
	move = true
	
func respawn():
	able_to_rotate = true
	raycast_enabled = false
	move = false
	get_parent().remove_child(self)
	main_body.add_child(self)
	current_body = main_body
	position = Vector2(0, 0)
	$Pointer.position = Vector2(0, -current_body.get_node("CollisionShape2D").shape.radius * current_body.scale.y) * 12.3
	
