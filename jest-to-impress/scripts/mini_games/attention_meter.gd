extends Node2D

# attention_meter.gd: This script manages the graphical representation of the
#                     attention meter.
#
# Author(s): Adam Goodyear

@onready var progress_bar = get_node("CanvasLayer/TextureProgressBar")

func _ready():
	progress_bar.max_value = GamestateManager.ATTENTION_METER_MAX

# Updates the visual appearance of the attention meter every frame based on the
# attention left
func _process(_delta):
	progress_bar.value = GamestateManager.attention_meter.time_left
