extends TextureRect

func _ready():
	$AnimationPlayer.play("destroy")
	yield($AnimationPlayer, "animation_finished")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "destroy":
		queue_free()
