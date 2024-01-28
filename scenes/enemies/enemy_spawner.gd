extends Node2D

class_name EnemySpawner

onready var gs = $"/root/GameState"
onready var ut = $"/root/Utils"
onready var mover = $Mover
onready var enemy_shot = $EnemyShot

export var enemy_scene : PackedScene
export var enemy_laser : PackedScene
export var enemy_speed: float = 1.0

const ROWS = 4
const COLS = 11
const H_SPACE = 32
const V_SPACE = 32
const ENEMY_HEIGHT = 32
const ENEMY_WIDTH = 32
const START_Y_POS = 50
const POS_X_INCR = 16
const POS_Y_INCR = 32

var screensize = Vector2.ZERO
var move_dir = -1

var enemy_list = [
	preload("res://assets/enemies/enemy_1.tres"),
	preload("res://assets/enemies/enemy_2.tres"),
	preload("res://assets/enemies/enemy_3.tres"),
	preload("res://assets/enemies/enemy_4.tres")
]

var next_wave = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	mover.connect("timeout", self, "move_enemies")
	enemy_shot.connect("timeout", self, "on_enemy_shot")
	enemy_shot.wait_time = ut.randi_range(2, 4)
	create_enemies()
	mover.start()

func _process(_delta):
	var enemy_modifier =  enemy_speed - float(len(get_tree().get_nodes_in_group("enemies"))) / float((COLS*ROWS))
	var wave_modifier = .75 if gs.current_wave <= 0 else float(enemy_speed) / float(gs.current_wave+1)
	mover.wait_time = clamp(enemy_speed - (clamp((enemy_modifier * wave_modifier)*3, 0.2, 1.0)), 0.4, 1)
#	print(len(get_tree().get_nodes_in_group("enemies")), " ", enemy_modifier, " ", wave_modifier, " ", clamp((enemy_modifier * wave_modifier)*3, 0, 1), " ", mover.wait_time)

func create_enemies():
	var enemies = enemy_list
	position = Vector2(0, 0)
	for row in ROWS:
		var space_taken = (COLS * (ENEMY_WIDTH+3))
		var left_over = screensize.x - space_taken
		var start_x = position.x + (left_over/2) 
		for col in COLS:
			# warning-ignore:integer_division
			var x = start_x + ((col+1) * (ENEMY_WIDTH+H_SPACE/2))
			var y = START_Y_POS + ((row) * ENEMY_HEIGHT) + (row * V_SPACE)
			var spawn_pos = Vector2(x, y)
			if spawn_pos < Vector2(0, 0) or spawn_pos > screensize:
				print(spawn_pos)
			spawn_enemy(enemies[randi() % enemies.size()], spawn_pos)

func spawn_enemy(enemy_data, spawn: Vector2):
	var enemy = enemy_scene.instance()
	enemy.config = enemy_data
	enemy.points = enemy.config.points
	enemy.load_image(enemy.config)
	enemy.global_position = spawn
	add_child(enemy)

func move_enemies():
	position.x += POS_X_INCR * move_dir

func on_enemy_shot():
	if len(get_tree().get_nodes_in_group("enemies")) > 0:
		var fighter_pos = get_tree().get_nodes_in_group("enemies")[randi() % get_tree().get_nodes_in_group("enemies").size()].global_position
		var enemyshot = enemy_laser.instance() as EnemyLaser
		enemyshot.source = "alien"
		enemyshot.global_position = fighter_pos
		if gs.game_mode == gs.game_modes.PLAYING:
			get_parent().add_child(enemyshot)

func start_next_wave():
	gs.next_wave(1)
	create_enemies()

func _on_left_area_entered(area):
	if area is Enemy:
		if (move_dir == -1):
			position.y += POS_Y_INCR
			move_dir *= -1

func _on_right_area_entered(area):
	if area is Enemy:
		if (move_dir == 1):
			position.y += POS_Y_INCR
			move_dir *= -1
