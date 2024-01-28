extends Node2D

signal curtainsDown

func _beginAnimation():
	GamestateManager.pause()
	$AnimationPlayer.play("Transition")

func _curtainsDown():
	emit_signal("curtainsDown")

func _finishedAnimation():
	if !GamestateManager.show_tutorials:
		GamestateManager.resume()
