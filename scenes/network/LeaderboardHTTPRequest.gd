extends HTTPRequest

onready var ut = $"/root/Utils"
onready var url = ut.score_api

var scores
signal done

func _ready():
	var headers = []
	headers.append("Access-Control-Allow-Origin: *")
	headers.append("Content-Type: application/json")
	headers.append("abigdumbchallenge: %s" % ut.score_api_read_key)
	var _err = self.connect("request_completed", self, "_on_request_completed")
#	print_debug("getting highscore data")
	var _res = self.request("https://%s" % url, headers, true, HTTPClient.METHOD_GET)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
#		print_debug("got highscore data")
		var json = JSON.parse(body.get_string_from_utf8()).result
#		print_debug("Got: ", len(json))
		scores = json
		emit_signal("done")
