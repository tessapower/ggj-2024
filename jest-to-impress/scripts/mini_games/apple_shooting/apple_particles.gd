extends Node2D

## apple_particles.gd: A script to manage the apple explosion particles.
##
## Author(s): Adam Goodyear

func _ready():
	$CPUParticles2D.emitting = true

func _on_cpu_particles_2d_finished():
	queue_free()
