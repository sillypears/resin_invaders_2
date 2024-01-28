extends Control

onready var gs = $"/root/GameState"
signal done

func _on_GetCardsHTTPRequest_done():
#	print_debug("in resin cards: ", len(gs.cap_cards))
	emit_signal("done")
