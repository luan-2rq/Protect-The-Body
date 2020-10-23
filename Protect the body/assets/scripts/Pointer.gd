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
var raycasts

func _ready():
	$Pointer/AnimatedSprite.play("idle")
	main_body = get_parent()
	current_body = main_body
	pointer = $Pointer
	raycasts = [pointer.get_node("RayCast2D"), pointer.get_node("RayCast2D2"), pointer.get_node("RayCast2D3")]
	#get_parent().get_parent().connect("respawn", self, "on_Stage_respawn")

func _input(event):
	if event.is_action_pressed("pointer_shoot") && current_body != null && !is_moving && !Global.ninja:
		call_deferred("shoot")

func _physics_process(delta):
	if !is_moving and $Pointer/Timer.is_stopped():
		global_rotation = atan2(-(global_position.x - get_global_mouse_position().x), global_position.y - get_global_mouse_position().y)
	
	if is_moving and $Pointer/Timer.is_stopped():
		pointer.move_and_slide(Vector2(0, -shoot_speed * Global.velocity_modifier).rotated(self.global_rotation))
	for i in range(raycasts.size()):
		if raycasts[i].is_colliding() && raycast_enabled:
			if raycasts[i].get_collider().is_in_group("body") && raycasts[i].get_collider() != current_body:
				spawn_on_body()
	
	if Global.ninja:
		respawn()
		$Pointer/AnimatedSprite.play("ninja")

	if !$Pointer/VisibilityNotifier2D.is_on_screen() && is_moving:
		respawn()

func shoot():
	var shoot_position = global_position
	var shoot_rotation = global_rotation
	
	$Pointer/AnimatedSprite.play("jumping")
	$Pointer/Timer.start()
	
	#Play the animation and wait it's end
	
	if current_body != main_body && !current_body.is_in_group("pivot"):
		current_body.die()
	
	raycast_enabled = true
	current_body.remove_child(self)
	main_body.get_node("/root").add_child(self)
	global_position = shoot_position
	global_rotation = shoot_rotation
	is_moving = true
	$Pointer/Jump_Effect.playing = true
	
	yield($Pointer/Timer, "timeout")
	pointer.rotation = pointer.rotation + PI
	
	$Pointer/AnimatedSprite.play("inJump")


func respawn():
	if Global.ninja:
		$Pointer/AnimatedSprite.play("ninja")
	else:
		$Pointer/AnimatedSprite.play("idle")
	if(is_moving):
		pointer.rotation = pointer.rotation + PI
	
	raycast_enabled = false
	is_moving = false
	
	get_parent().remove_child(self)
	main_body.add_child(self)
	current_body = main_body
	
	position = Vector2(0, 0)
	pointer.position = Vector2(0, -current_body.get_node("CollisionShape2D").shape.radius * current_body.scale.y) * 1.55

func spawn_on_body():
	$Pointer/AnimatedSprite.play("idle")
	is_moving = false
	raycast_enabled = false
	main_body.get_node("/root").remove_child(self)
	pointer.rotation = pointer.rotation + PI
	current_body = get_current_body()
	current_body.add_child(self)
	position =  Vector2(0, 0)
	var local_hit_position = current_body.to_local(get_raycast_collision_point())
	pointer.position = Vector2(0, -local_hit_position.length() - 29)
	rotation = atan2(local_hit_position.y, local_hit_position.x) + PI/2

func on_Global_clean():
	respawn()

func die():
	pass

func get_current_body():
	for i in range(raycasts.size()):
		if raycasts[i].get_collider():
			return  raycasts[i].get_collider()
	
func get_raycast_collision_point():
	for i in range(raycasts.size()):
		if raycasts[i].get_collider():
			return  raycasts[i].get_collision_point()
