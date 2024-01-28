extends Area2D

class_name EnemyLaser

export var speed = 800
export var source : String

func ready():
	pass

func _process(delta):
	global_position.y += delta * speed
