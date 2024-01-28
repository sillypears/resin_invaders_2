extends HTTPRequest

onready var gs = $"/root/GameState"
onready var ut = $"/root/Utils"
onready var url = ut.card_api

signal done

onready var getting_caps = $"../GettingCaps"
onready var got_caps = $"../GotCaps"


var req_list : Dictionary


func _ready():
	getting_caps.show()
	var headers = []
	headers.append("Access-Control-Allow-Origin: *")
	headers.append("Content-Type: application/json")
	headers.append("ohthereyouare: %s" % ut.card_api_key)
	var _err = self.connect("request_completed", self, "_on_request_completed")
	var _res = self.request("https://%s/random-cap/5"% url, headers, HTTPClient.METHOD_GET)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
		getting_caps.hide()
		got_caps.show()
		var caps = JSON.parse(body.get_string_from_utf8()).result
#		print_debug("got caps: ", len(caps))
		gs.cap_count = len(caps)
		for cap in caps:
			var text_rect = TextureRect.new()
			text_rect.rect_min_size = Vector2(64, 64)
			var new_img = Image.new()
			var new_imgtxt = ImageTexture.new()
			var err
			match cap.texture.type.ext:
				"png":
					err = new_img.load_png_from_buffer(Marshalls.base64_to_raw(cap.texture.data))
				"jpg":
					err = new_img.load_jpg_from_buffer(Marshalls.base64_to_raw(cap.texture.data))
				"webp":
					err = new_img.load_webp_from_buffer(Marshalls.base64_to_raw(cap.texture.data))
			if err:
				print_debug("err: ", err, " url: ", cap.img)
				continue
			new_imgtxt.create_from_image(new_img)
			text_rect.texture = new_imgtxt
			
			req_list[cap.id] = {
				"cap": cap,
				"texture": text_rect
			}
		gs.cap_cards = req_list
		var t := Timer.new()
		t.wait_time = 1
		t.one_shot = true
		var _err = t.connect("timeout", self, "_on_timer_timeout")
		add_child(t)
		t.start()

func _on_timer_timeout():
#	print_debug("hiding: ", len(gs.cap_cards))
	got_caps.hide()
	emit_signal("done")
