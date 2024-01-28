extends CanvasLayer

onready var gs = $"/root/GameState"
onready var scores = $TitleContainer/Intro/Scores

func _ready():
	gs.reset()
	gs.game_mode = gs.game_modes.TITLE

func _on_StartGame_pressed():
	print_debug("Startin game")
	var _err = get_tree().change_scene("res://scenes/game/game.tscn")
