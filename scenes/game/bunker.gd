extends Area2D

signal trampled

onready var gs = $"/root/GameState"

func _on_bunker_area_entered(area):
	if area is EnemyLaser:
		gs.add_dodged_shot(1)
		area.queue_free()
	if area is Enemy:
		gs.game_mode = gs.game_modes.GAMEOVER
		emit_signal("trampled", "trampled")
