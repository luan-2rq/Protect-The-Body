extends Wave

func _ready():
	self._change(2)
	
	total_enem = enemy1_init + enemy2_init

func _start():
	$Change.call_deferred("free")
	$Enemy1_spawn.start()
	$Enemy2_spawn.start()

