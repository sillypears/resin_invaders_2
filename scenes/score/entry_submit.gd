extends CanvasLayer

onready var gs = $"/root/GameState"
onready var submit_highscore = $SubmitHighscore
onready var bad_word_list = gs.bad_words_array
onready var entry_name = $Container/SubmitContainer/NameContainer/NameEntry
onready var your_score = $Container/SubmitContainer/ScoreContainer/ScoreData
onready var your_email = $Container/SubmitContainer/EmailContainer/EmailEntry
onready var email_entry = $Container/SubmitContainer/VBoxContainer2/HBoxContainer/EmailEntry

var submit_template = {
	"submitted": "2020-01-06T16:24:07.265Z",
	"wave": 2,
	"score": 443,
	"diedTo": "i cheated",
	"name": "dumbass",
	"email": "dumbass@yahoo.com",
	"agreed": false,
	"enemiesKilled": 13,
	"secondsPlayed": 125,
	"dodgedShots": 323,
	"missedShots": 200,
	"resinCards": []
}

func _ready():
	your_score.text = str(gs.current_score)
	entry_name.grab_focus()

func validate_entry():
	if entry_name.text == null or entry_name.text == "":
		entry_name.text = ""
		entry_name.placeholder_text = "be better"
		print_debug("stop that")
		return
	if your_email.text == "" or not is_valid_email(your_email.text):
		your_email.text = ""
		your_email.placeholder_text = "be better"
		print_debug("what is wrong with you") 
		return
	if entry_name.text.to_lower() in bad_word_list:
		entry_name.text = ""
		entry_name.placeholder_text = "naughty gremlin"
		print_debug("now you just a dick")
		return
	submit_template.submitted = Time.get_datetime_string_from_system()
	submit_template.score = gs.current_score
	submit_template.wave = gs.current_wave
	submit_template.diedTo = gs.killed_by
	submit_template.name = entry_name.text
	submit_template.email = your_email.text
	submit_template.agreed = email_entry.pressed
	submit_template.enemiesKilled = gs.enemies_killed
	submit_template.secondsPlayed = gs.time_spent
	submit_template.dodgedShots = gs.dodged_shots
	submit_template.missedShots = gs.missed_shots
	var card_submission = []
	for card in gs.cap_cards:
		var c = {}
		c['id'] = gs.cap_cards[card].cap.id
		c['maker'] = gs.cap_cards[card].cap.maker
		c['sculpt'] = gs.cap_cards[card].cap.sculpt
		c['colorway'] = gs.cap_cards[card].cap.colorway
		card_submission.append(c)
	submit_template.resinCards = card_submission

	#Try to submit it lol
	submit_highscore.post_scores(submit_template)

# Function to check if an email is valid
func is_valid_email(email: String) -> bool:
	var regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
	var pattern = RegEx.new()
	if pattern.compile(regex) == OK:
		return true if pattern.search(email) != null else false
	else:
		return false
