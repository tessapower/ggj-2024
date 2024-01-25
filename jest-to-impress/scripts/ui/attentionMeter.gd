extends Node2D

signal attentionOut

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/TextureProgressBar.max_value = $Timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/TextureProgressBar.value = $Timer.time_left
	if get_attention() < 0:
		emit_signal("attentionOut")

func set_attention(attention : int):
	$Timer.start(attention)

func get_attention() -> int:
	return $Timer.time_left
	
func get_max_attention() -> int:
	return $Timer.wait_time
	
func set_max_attention(attention : int):
	$Timer.wait_time = attention
	$CanvasLayer/TextureProgressBar.max_value = attention
	
