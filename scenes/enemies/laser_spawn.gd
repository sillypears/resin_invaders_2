extends Node2D

export var laser_scene : PackedScene

var can_enemy_shoot = true

func on_laser_destroyed():
	can_enemy_shoot = true

func _on_FiringTimer_timeout():
	if can_enemy_shoot:
		var laser = laser_scene.instance()
		can_enemy_shoot = false
		laser.global_position = get_parent().global_position - Vector2(0, 20)
		get_parent().add_child(laser)
		laser.connect("tree_exited", self, "on_laser_destroyed")
