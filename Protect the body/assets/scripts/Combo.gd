extends Control

var counter : int = 0
var first : bool = true

func _update_mult() -> void:
	counter += 1
	
	if first:
		_appear($Combo_Text/AnimationPlayer)
		first = false
	else:
		_disappear($Multiplier/AnimationPlayer)
		yield($Multiplier/AnimationPlayer, "animation_finished")
	
	$Multiplier.text = ("x%s" % counter)
	_appear($Multiplier/AnimationPlayer)
	
	$Timer.start()

func _reset_mult() -> void:
	counter = 0
	first = true
	
	_disappear($Combo_Text/AnimationPlayer)
	_disappear($Multiplier/AnimationPlayer)
	yield($Multiplier/AnimationPlayer, "animation_finished")
	$Multiplier.text = ("x%s" % counter)

func _appear(child) -> void:
	child.play("Appearing")

func _disappear(child) -> void:
	child.play("Disappearing")

func _on_Timer_timeout() -> void:
	_reset_mult()
