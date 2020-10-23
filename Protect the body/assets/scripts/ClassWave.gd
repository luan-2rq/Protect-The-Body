extends Node2D

class_name Wave

export(PackedScene) var wave_change_scene
export(PackedScene) var next_scene

export(PackedScene) var enemy1_scene
export(PackedScene) var enemy2_scene
export(PackedScene) var enemy3_scene
export(PackedScene) var enemy4_scene
export(PackedScene) var enemy5_scene
export(PackedScene) var enemy6_scene
export(PackedScene) var enemy7_scene

var enemy1_num  : int = 2
var enemy2_num  : int
var enemy3_num  : int
var enemy4_num  : int
var enemy5_num  : int
var enemy6_num  : int
var enemy7_num  : int

var enemy1_init : int = enemy1_num
var enemy2_init : int = enemy2_num
var enemy3_init : int = enemy3_num
var enemy4_init : int = enemy4_num
var enemy5_init : int = enemy5_num
var enemy6_init : int = enemy6_num
var enemy7_init : int = enemy7_num

var enemy1_dead : int
var enemy2_dead : int
var enemy3_dead : int
var enemy4_dead : int
var enemy5_dead : int
var enemy6_dead : int
var enemy7_dead : int

var wave_num  : String

var end : bool = false

signal wave_end

func _change(title):
	pass
