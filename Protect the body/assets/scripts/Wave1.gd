extends Wave

func _ready():
	self._change(1)
	
	total_enem = enemy1_init

func _start():
	$Change.call_deferred("free")
	$Enemy1_spawn.start()
