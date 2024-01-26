extends Node2D

signal attentionOut

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/TextureProgressBar.max_value = GamestateManager.attention_meter_max

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/TextureProgressBar.value = GamestateManager.attention.time_left
	if GamestateManager.attention.time_left <= 0:
		emit_signal("attentionOut")
	
