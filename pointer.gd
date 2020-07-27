extends Sprite

var speed = 0.5
var velocity = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	if Input.is_action_pressed('ui_right'):
		velocity += 1
	if Input.is_action_pressed('ui_left'):
		velocity -= 1
	

func _physics_process(delta):
	global_rotation = atan2(-(self.get_global_position().x - self.get_global_mouse_position().x), self.get_global_position().y - self.get_global_mouse_position().y)
	#get_input()
	#rotation += velocity * speed * delta
