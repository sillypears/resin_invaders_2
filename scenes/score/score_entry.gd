extends HBoxContainer

class_name ScoreEntry

onready var pname 
onready var score 
onready var died
onready var seconds

func _ready():
	update_labels(pname, score, died, seconds)

func update_labels(n, s, d, t):
	$NameLabel.text = "%s" % n
	$ScoreLabel.text = "%s" % s
	$DiedLabel.text = "%s" % d
	$SecondsLabel.text = "%s" % t
