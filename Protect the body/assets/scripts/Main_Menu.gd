extends Control

export(PackedScene) var heart_stage_scene
export(Texture) var arrow

var x:  BlockingDialogBox

func _ready():
	Input.set_custom_mouse_cursor(arrow)
	x = get_node("/root/Main_Menu/Dialog")
	x.append_text("My chest is hurting help me [rainbow] player [/rainbow]!!!!!!!!!!!!",30)

func _on_Heart_Area_mouse_entered():
	$Heart/AnimationPlayer.play("Showing")

func _on_Heart_Area_mouse_exited():
	$Heart/AnimationPlayer.play("Disappearing")

func _transition():
	$Heart/Heart_Bg.modulate.a = 1
	$Heart/Heart_Animation.modulate.a = 1
	$Heart/Heart_Frame.modulate.a = 1
	get_tree().paused = true
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(0.1, 0.1), 0.5)
	$Tween.interpolate_property($Camera2D, "position", $Camera2D.position, Vector2(600, 200), 0.5)
	$Tween.start()

func _on_Heart_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		_transition()

func _on_Tween_tween_all_completed():
	get_tree().change_scene_to(heart_stage_scene)
