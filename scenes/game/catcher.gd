extends Area2D

onready var gs = $"/root/GameState"

func catch_player_lasers(area):
	if area is Laser:
		gs.missed_shots += 1
		area.queue_free() 
