extends Control

onready var gs = $"/root/GameState"
onready var gameover = "res://scenes/gameover/game_over.tscn"
onready var enemy_spawner = $EnemySpawner
var konami_code = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]
var konami_index = 0

func _ready():
	gs.game_mode = gs.game_modes.PLAYING

func _process(_delta):
	if Input.is_action_just_pressed("autodie"):
		#game over
		gs.game_mode = gs.game_modes.DEAD
		gs.killed_by = "secret death"
		var _err = get_tree().change_scene(gameover)
		
	if len(get_tree().get_nodes_in_group("enemies")) <= 0:
		gs.next_wave(1)
		enemy_spawner.create_enemies()
		var _err = get_tree().create_timer(1)

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			check_konami_code(event.scancode)

func check_konami_code(key):
	if key == konami_code[konami_index]:
		konami_index += 1
		if konami_index == len(konami_code):
			gs.game_over("konami'd")
			get_tree().change_scene(gameover)
			konami_index = 0  # Reset for the next input
	else:
		konami_index = 0  # Reset if the wrong key is pressed
		
func _on_GameTime_timeout():
	gs.time_spent += 1

func _on_Player_dead(killed):
	gs.killed_by = killed
	for x in get_tree().get_nodes_in_group("enemies"):
		x.queue_free()
	for x in get_tree().get_nodes_in_group("card_enemies"):
		x.queue_free()
	for x in get_tree().get_nodes_in_group("enemy_lasers"):
		x.queue_free()
	var _err = get_tree().change_scene(gameover)

func _on_Bunker_trampled(killed):	
	gs.killed_by = killed
	for x in get_tree().get_nodes_in_group("card_enemies"):
		x.queue_free()
		var _err = get_tree().change_scene("res://scenes/gameover/game_over.tscn")
