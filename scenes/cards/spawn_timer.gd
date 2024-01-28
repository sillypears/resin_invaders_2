extends Timer

class_name SpawnTimer

onready var gs = $"/root/GameState"
onready var ut = $"/root/Utils"

export var min_time = 3
export var max_time = 6

func _ready():
	setup_timer()

func setup_timer():
	var rand_time = ut.randi_range(min_time, max_time)
	self.wait_time = rand_time
	self.stop()
	self.start()
