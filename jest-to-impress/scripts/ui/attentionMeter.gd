extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/TextureProgressBar.max_value = $Timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/TextureProgressBar.value = $Timer.time_left
