extends Wave

func _ready():
	self._change(3)
	
	total_enem = enemy1_init + enemy2_init + enemy4_init

func _start():
	$Change.call_deferred("free")
	$Enemy1_spawn.start()
	$Enemy2_spawn.start()
	$Enemy4_spawn.start()
