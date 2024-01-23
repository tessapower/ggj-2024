extends Area2D

# range_bar.gd: This script contains the code for for the range bars used in the
#               knife-throwing mini-game.
#
# Author(s): Tessa Power


@export var width_scale = 1.0
@export var color = Color(1, 1, 1, 1)

# Components of the range bar
@onready var color_rect = get_node('CollisionShape/Color')
@onready var collision_shape = get_node('CollisionShape')

func _ready() -> void:
	# Set the color of the color rect to the color of the node
	color_rect.color = color
	# Set the width of the collision shape to the width scale of the node
	update_width_scale(width_scale)


func update_width_scale(new_width_scale) -> void:
	# Update the width scale of the node
	width_scale = new_width_scale
	# Update the width of the collision shape
	collision_shape.scale.x *= width_scale
