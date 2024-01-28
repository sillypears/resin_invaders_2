extends Node

var card_api
var card_api_key
var score_api
var score_api_read_key
var score_api_write_key

func _ready():
	load_secrets()
	
func load_secrets():
	var config_file = ConfigFile.new()
	var load_result = config_file.load("res://secrets")
	if load_result == OK:
		card_api = config_file.get_value("card", "card_api")
		card_api_key = config_file.get_value("card", "card_api_key")
		
		score_api = config_file.get_value("score", "score_api")
		score_api_read_key = config_file.get_value("score", "score_api_read_key")
		score_api_write_key = config_file.get_value("score", "score_api_write_key")

	print(card_api, " ", score_api)
func randi_range(min_val: int, max_val: int) -> int:
	var rand = randi()
	var r = (rand % (max_val - min_val)) + min_val
	return r

func get_random_coords() -> Vector2:
	var size = get_tree().root.get_visible_rect().size
	var x_val = randi_range(50, size.x-100)
	var y_val = randi_range(50, size.y-100)
	return Vector2(x_val, y_val)

