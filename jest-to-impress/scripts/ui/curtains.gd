extends Node2D

signal curtains_down

func _begin_animation():
	GamestateManager.pause()
	$AnimationPlayer.play("Transition")

func _curtains_down():
	emit_signal("curtains_down")


func _finished_animation():
	pass
	#if !GamestateManager.show_tutorials:
		#GamestateManager.resume()
