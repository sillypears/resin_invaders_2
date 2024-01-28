extends Control

onready var submit_highscore_http_request = $SubmitHighscoreHTTPRequest

func post_scores(score):
	$Submitting.show()
	submit_highscore_http_request.submit_score(score)
