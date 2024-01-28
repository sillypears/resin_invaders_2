extends Control

export var boardEntry : PackedScene

onready var http_req = $LeaderboardHTTPRequest
#onready var list = $Table/Scroll/Entries/Panel/EntryList
onready var list = $Table/Scroll/EntryList
onready var loading_label = $LoadingLabel
onready var loaded_label = $LoadedLabel
onready var loaded_timer = $LoadedTimer

func _ready():
	loading_label.hide()
	loaded_label.hide()
	
	loading_label.show()
	yield(http_req, "request_completed")

func scores_loaded():
	loaded_label.hide() # Replace with function body.

func _on_LeaderboardHTTPRequest_done():
	for s in http_req.scores:
		var entry = boardEntry.instance()
		entry.pname = s['name']
		entry.score = s['score']
		entry.died = s['diedTo']
		entry.seconds = s['secondsPlayed']
		list.add_child(entry)
	loading_label.hide()
	loaded_label.show()
	loaded_timer.start()


func _on_LoadedTimer_timeout():
	loaded_label.hide()
