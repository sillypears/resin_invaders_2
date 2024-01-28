extends Area2D

class_name CardEnemy

onready var gs = $"/root/GameState"
onready var ut = $"/root/Utils"

export var points : int
export var location: Vector2
export var config : Resource
onready var firing_timer = $FiringTimer

var enemy_laser = preload("res://scenes/enemies/enemy_laser.tscn")
var destroy_scene = preload("res://scenes/enemies/destroy.tscn")

func _ready():
	config = load("res://assets/enemies/enemy_resin.tres")
	points = config.points
	$FiringTimer.wait_time = ut.randi_range(3, 5)
	
func load_image(enemy_config: Resource):
	$Sprite.texture = enemy_config.enemy

func set_texture(t: TextureRect):
	$Sprite.texture = t.texture

func _on_CardEnemy_area_entered(area):
	if area is Laser:
		area.queue_free()
		var destroy = destroy_scene.instance()
		destroy.set_global_position(position)
		get_tree().root.add_child(destroy)
		gs.add_points(points)
		gs.add_enemy_kills(1)
		queue_free()

func _on_FiringTimer_timeout():
	var enemyshot = enemy_laser.instance()
	var shot_sprite = enemyshot.get_node("Sprite") as Sprite
	enemyshot.source = "resin"
	shot_sprite.modulate = Color(0, 1, 0, 1)
	enemyshot.global_position = global_position - Vector2(0, 20)
	if gs.game_mode == gs.game_modes.PLAYING:
		get_tree().root.add_child(enemyshot)
