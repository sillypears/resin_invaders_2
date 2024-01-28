extends Node

#Main Game Data
export var start_wave = 1
export var current_wave = 0
export var time_spent = 0
export var enemies_killed = 0
export var missed_shots = 0
export var dodged_shots = 0
export var current_score = 0
export var total_lives = 3
export var killed_by = "i cheated"
var game_stats = [
	"current_wave",
	"time_spent",
	"enemies_killed",
	"missed_shots",
	"dodged_shots",
	"current_score",
	"total_lives",
	"killed_by"
]

#Bad Names List
export var bad_words = "res://assets/bad_name_list.txt"

enum game_modes {INIT, GATHER, TITLE, PLAYING, DEAD, GAMEOVER, RESTART}
var game_mode = game_modes.INIT

var can_move := false
var bad_words_array = []

#I don't remember
var cap_cards : Dictionary
var cap_count = 0

func _ready():
	game_mode = game_modes.INIT
	load_file(bad_words)

func load_file(f):
	var file = File.new()
	if file.open(f, File.READ) == OK:
		while not file.eof_reached():
			bad_words_array.append(file.get_line())
	file.close()	
	return

func reset():
	can_move = true
	current_wave = start_wave
	time_spent = 0
	enemies_killed = 0
	missed_shots = 0
	dodged_shots = 0
	current_score = 0
	total_lives = 3
	killed_by = "reset lol"

func next_wave(value):
	current_wave += value

func add_points(value):
	current_score += value

func add_enemy_kills(value):
	enemies_killed += value

func add_missed_shot(value):
	missed_shots += value

func add_dodged_shot(value):
	dodged_shots += value

func lose_life(value):
	total_lives -= value

func add_life(value):
	total_lives += value

func game_over(reason):
	killed_by = reason
	game_mode = game_modes.DEAD
