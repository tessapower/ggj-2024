extends Node2D

var mouseDetected = false
const PARTICLES = preload("res://scenes/mini_games/apple_shooting/apple_particles.tscn")

signal missed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy_apple():
	GamestateManager.update_attention_meter(1)
	$Sprite2D.hide()
	var particle_instance = PARTICLES.instantiate()
	particle_instance.global_position = global_position
	get_parent().add_child(particle_instance)
	queue_free()

func _on_mouse_entered():
	mouseDetected = true
func _on_mouse_exited():
	mouseDetected = false
