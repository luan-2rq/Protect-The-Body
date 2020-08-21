extends Node2D

var main_body
var main_body_speed = 300
var current_body
var is_moving = false
var raycast_enabled = false
export(int)var shoot_speed
export(int)var rotation_speed
var rotation_direction = 0
var pointer

func get_input():
	if Input.is_action_just_released(('ui_right')):
		rotation_direction = 0
	if Input.is_action_just_released(('ui_left')):
		rotation_direction = 0
	if Input.is_action_just_pressed("ui_accept") && current_body != null && !is_moving:
		call_deferred("shoot")

func _ready():
	main_body = get_parent()
	current_body = main_body
	#get_parent().get_parent().connect("respawn", self, "on_Stage_respawn")

func _physics_process(delta):
	get_input()
	#if current_body == main_body and !is_moving:
		#main_body.move_and_slide(main_body.position.direction_to(get_global_mouse_position()) * main_body_speed)
	if !is_moving:
		global_rotation = atan2(-(global_position.x - get_global_mouse_position().x), global_position.y - get_global_mouse_position().y)
	if is_moving:
		$Pointer.move_and_slide(Vector2(0, -shoot_speed * Global.velocity_modifier).rotated(self.global_rotation))
	if $Pointer.get_node("RayCast2D").is_colliding() && raycast_enabled:
		if $Pointer.get_node("RayCast2D").get_collider().is_in_group("body"):
			is_moving = false
			raycast_enabled = false
			main_body.get_node("/root").remove_child(self)
			current_body = $Pointer.get_node("RayCast2D").get_collider()
			current_body.add_child(self)
			position =  Vector2(0, 0)
			var local_hit_position = current_body.to_local($Pointer.get_node("RayCast2D").get_collision_point())
			$Pointer.position = Vector2(0, -current_body.get_node("CollisionShape2D").shape.radius * current_body.scale.y) * 1.8
			rotation = atan2(local_hit_position.y, local_hit_position.x) + PI/2
		if $Pointer.get_node("RayCast2D").get_collider().is_in_group("powerup"):
			$Pointer.get_node("RayCast2D").get_collider().collected()
	if !$Pointer/VisibilityNotifier2D.is_on_screen() && is_moving:
		respawn()
			
func shoot():
	var shoot_position = global_position
	var shoot_rotation = global_rotation
	if current_body != main_body && !current_body.is_in_group("pivot"):
		current_body.die()
	raycast_enabled = true
	current_body.remove_child(self)
	main_body.get_node("/root").add_child(self)
	global_position = shoot_position
	global_rotation = shoot_rotation
	is_moving = true
	$Pointer/Jump_Effect.playing = true
	
func respawn():
	raycast_enabled = false
	is_moving = false
	get_parent().remove_child(self)
	main_body.add_child(self)
	current_body = main_body
	position = Vector2(0, 0)
	$Pointer.position = Vector2(0, -current_body.get_node("CollisionShape2D").shape.radius * current_body.scale.y) * 1.8
	
#func on_Stage_respawn():
	#call_deferred("respawn")
	

