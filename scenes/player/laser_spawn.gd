extends Node2D

onready var gs = $"/root/GameState"
export var laser_scene : PackedScene

var can_we_shoot = true

func _input(_event):
	if Input.is_action_pressed("shoot") and can_we_shoot and gs.game_mode == gs.game_modes.PLAYING:
		var laser = laser_scene.instance() as Laser
		can_we_shoot = false
		laser.global_position = get_parent().global_position - Vector2(0, 20)
		get_tree().root.get_node("Game").add_child(laser)
		laser.connect("tree_exited", self, "on_laser_destroyed")

func on_laser_destroyed():
	can_we_shoot = true
