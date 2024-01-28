extends Control

onready var gs = $"/root/GameState"

func _ready():
	gs.game_mode = gs.game_modes.GATHER

func _on_ResinCards_done():
#	print_debug("main setup: cards->", len(gs.cap_cards) )
	var _err = get_tree().change_scene("res://scenes/ui/title.tscn")
