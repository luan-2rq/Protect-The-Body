extends KinematicBody2D
class_name Enemy

export (int) var speed
export (AudioStream) var die_sfx

var rng = RandomNumberGenerator.new()
var resolution = OS.get_window_size()
var acel
var plain
var fruit_ninja_power_up = false

signal die

func _ready():
	$AudioStreamPlayer2D.stream = die_sfx
	
	rng.seed = 300
	rng.randomize()
	
	plain = rng.randi_range(1,4)

func die():
	$AudioStreamPlayer2D.playing = true
	$AnimationPlayer.play("die")
	
	var points = preload("res://assets/HUD/Points/Point animation.tscn").instance()
	add_child(points)
	points.get_node("AnimationPlayer").connect("animation_finished", self, "_on_Points_Animation_finished")
	points.get_node("AnimationPlayer").play("IDLE")
	
	emit_signal("die")
	#$Sprite.visible = false
	$CollisionShape2D.disabled = true
	$CPUParticles2D.visible = false
	set_physics_process(false)

func _on_Points_Animation_finished(IDLE):
	call_deferred("free")
