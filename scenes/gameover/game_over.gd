extends CanvasLayer


onready var gs = $"/root/GameState"
onready var stats = $Container/StatsContainer
var font = preload("res://assets/fonts/gameover_stat_font.tres")

func _ready():
	gs.game_mode = gs.game_modes.GAMEOVER
	for x in get_tree().get_nodes_in_group("enemies"):
		x.queue_free()
	for x in get_tree().get_nodes_in_group("card_enemies"):
		x.queue_free()
	for x in get_tree().get_nodes_in_group("enemy_lasers"):
		x.queue_free()
	
	for stat in gs.game_stats:
		var hbox = HBoxContainer.new()
		hbox.add_constant_override("separation", 60)
		var label = Label.new()
		var statlabel = Label.new()
		
		label.add_font_override("font", font)
		statlabel.add_font_override("font", font)

		label.align = Label.ALIGN_LEFT
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		statlabel.align = Label.ALIGN_RIGHT
		statlabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		label.text = stat.replace("_", " ")
		statlabel.text = str(gs[stat])

		hbox.add_child(label)
		hbox.add_child(statlabel)
		stats.add_child(hbox)

func gather_data_for_entry():
	var _err = get_tree().change_scene("res://scenes/score/entry_submit.tscn")
