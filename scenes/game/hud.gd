extends Control

onready var gs = $"/root/GameState"

onready var score = $Container/Box/Score
onready var timer = $Container/Box/Timer
onready var lives = $Container/Box/LifeCounter/Lives

func _process(_delta):
	score.text = str(gs.current_score)
	timer.text = str(gs.time_spent)
	lives.text = str(gs.total_lives)
