extends Node2D

## curtains.gd: This script manages the curtains that are lowered and raised
##              in between mini-games.
##
## Author(s): Adam Goodyear

signal curtains_down

func _begin_animation():
	# Pause gameplay (but not the music) while the curtains animation plays
	GamestateManager.pause_gameplay(true)
	$AnimationPlayer.play("Transition")


func _curtains_down():
	emit_signal("curtains_down")
