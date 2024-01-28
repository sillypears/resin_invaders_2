extends Area2D

class_name Laser

export var speed = 800
onready var pew_player = $PewPlayer

func _process(delta):
	position.y -= delta * speed
