extends HTTPRequest

onready var ut = $"/root/Utils"
onready var url = ut.score_api
var scores
signal done

func submit_score(dataObject):
	var headers = ["Content-Type: application/json", "howdoidothisagain: %s" % ut.score_api_write_key]
	var _conn = self.connect("request_completed", self, "_on_request_completed")
#	print_debug("getting ready to post")
	var _req = self.request("https://%s/add-score" % url, headers, true, HTTPClient.METHOD_POST, JSON.print(dataObject))
#	print_debug("after post")

func _on_request_completed(_result, response_code, _headers, _body):
#	print_debug("getting posted data")
	if response_code == HTTPClient.RESPONSE_OK:
#		print_debug("data posted")
		emit_signal("done")
		# change scene to title
		var _ch = get_tree().change_scene("res://scenes/ui/title.tscn")
	else:
		print_debug("Failed to submit cheater :)")
