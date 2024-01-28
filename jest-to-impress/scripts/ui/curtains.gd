extends Node2D

signal curtains_down

func _begin_animation():
	# Pause gameplay (but not the music) while the curtains animation plays
	GamestateManager.pause_gameplay(true)
	$AnimationPlayer.play("Transition")


func _curtains_down():
	emit_signal("curtains_down")


func _finished_animation():
	# Resume gameplay
	GamestateManager.pause_gameplay(false)
