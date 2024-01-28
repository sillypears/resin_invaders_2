#enemy.gd
extends Area2D

class_name Enemy

#Signals

#Values
var points : int
var can_enemy_shoot = true
export var config : Resource

#Imports
onready var laser_spawn = $LaserSpawn
onready var gs = $"/root/GameState"
onready var firing_timer = $FiringTimer
onready var sprite = $Sprite

onready var ut = $"/root/Utils"

func _ready():
	$AnimationPlayer.play("move")
	firing_timer.start(ut.randi_range(5, 25))

func _process(_delta):
	pass

func load_image(enemy_config: Resource):

	$Sprite.texture = enemy_config.enemy

func _on_animationPlayer_animation_finished(anim_name):
	if anim_name == "destroy":
		queue_free()

func _on_enemy_area_entered(area):
	if area is Laser:
		$Sprite.texture = preload("res://assets/enemies/destroy-sheet.png")
		gs.add_points(points)
		gs.add_enemy_kills(1)
		$AnimationPlayer.play("destroy")
		area.queue_free()
#		print_debug(len(get_tree().get_nodes_in_group("enemies")))
