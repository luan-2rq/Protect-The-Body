extends Control

export(PackedScene) var heart_stage_scene
export(Texture) var arrow

func _ready():
	Input.set_custom_mouse_cursor(arrow)

func _on_Heart_Area_mouse_entered():
	$Heart/AnimationPlayer.play("Showing")

func _on_Heart_Area_mouse_exited():
	$Heart/AnimationPlayer.play("Disappearing")

func _on_Heart_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to(heart_stage_scene)
