extends Area2D

class_name Player
signal dead

onready var gs = $"/root/GameState"

onready var collision: CollisionShape2D = $CollisionShape2D
onready var ow_player = $OwPlayer
onready var death_player = $DeathPlayer

var move_speed = 250
var direction = Vector2.ZERO
var can_be_hit = true
onready var invincible = $Invincible

var bounds
var screensize = Vector2(768, 1024)
var sta_bound
var end_bound

func _ready():
	gs.can_move = true
	$AnimationPlayer.play("move")
	bounds = collision.shape.extents.x / 2
	var vis_rect = get_viewport().get_visible_rect()
	sta_bound = 0
	end_bound = vis_rect.size.x

func _process(delta):
	if gs.can_move:
		var input = Input.get_axis("move_left", "move_right")
		if input > 0:
			direction = Vector2.RIGHT
			$Sprite.flip_h = false
		elif input < 0:
			direction = Vector2.LEFT
			$Sprite.flip_h = true
		else:
			direction = Vector2.ZERO
		var delta_move = move_speed * delta * direction.x

#		testing bounds of box
		if position.x + delta_move < sta_bound + bounds * transform.get_scale().x \
		|| position.x + delta_move > end_bound - bounds * transform.get_scale().x:
			return
		position.x += delta_move

func dead():
	print_debug("I'm dead")
	emit_signal("dead")
	gs.can_move = false
	gs.game_mode = gs.game_modes.DEAD
	if not death_player.playing:
		death_player.play()
		yield(death_player, "finished")
		queue_free()


func _on_invincible_timeout():
	can_be_hit = true
	self.modulate  = Color(1, 1, 1, 1)


func _on_player_area_entered(area):
	if area is EnemyLaser and can_be_hit:
		var source = area.source
		gs.lose_life(1)
		
		if gs.total_lives <= 0:
			invincible.queue_free()
			gs.game_mode = gs.game_modes.DEAD
			self.modulate = Color(1, 1, 1, .5)
			
			can_be_hit = false
			move_speed = 0
			death_player.play()
			yield(death_player, "finished")
			emit_signal("dead", source)
			return
		can_be_hit = false
		ow_player.play()
		invincible.start()
		self.modulate = Color(1, 0, 0, .5)
