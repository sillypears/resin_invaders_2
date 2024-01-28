extends Node2D

class_name CardSpawner

onready var gs = $"/root/GameState"
onready var ut = $"/root/Utils"
onready var spawn_timer = $SpawnTimer
export var card_scene: PackedScene

var move_dir = 1
func _ready():
	spawn_timer.setup_timer()

func _on_SpawnTimer_timeout():
	var card = card_scene.instance() as CardEnemy
	var cap_keys = gs.cap_cards.keys()
	var random_card_key = cap_keys[randi() % gs.cap_cards.size()]
	var random_card = gs.cap_cards[random_card_key]
	card.set_texture(random_card.texture)
	card.global_position = ut.get_random_coords()
	card.location = card.global_position
	get_tree().root.add_child(card)
