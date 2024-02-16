extends Node2D

## apple.gd: Handles detecting if the player has clicked on an apple, and if
##           so, explodes it!
##
## Author(s): Adam Goodyear

var mouse_detected = false
const PARTICLES = preload("res://scenes/mini_games/apple_shooting/apple_particles.tscn")

signal missed

func destroy_apple():
	GamestateManager.update_attention_meter(MiniGame.Rating.AVERAGE)

	$Sprite2D.hide()
	var particle_instance = PARTICLES.instantiate()
	particle_instance.global_position = global_position
	get_parent().add_child(particle_instance)
	queue_free()


func _on_mouse_entered():
	mouse_detected = true


func _on_mouse_exited():
	mouse_detected = false
