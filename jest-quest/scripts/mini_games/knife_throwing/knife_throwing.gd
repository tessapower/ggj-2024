extends "res://scripts/mini_games/mini_game.gd"

var game_name = "Knife-throwing"
var game_description = "Throw knives at the target. The closer to the center, the more points you get."

@onready var aim_bar_path = get_node("AimPath/PathFollow")

@export var speed_multiplier = 1.0
var speed = 0.2

func _process(delta) -> void:
    # Check how far along the path the aim bar is
    var progress_ratio = aim_bar_path.progress_ratio
    if progress_ratio >= 1.0 or progress_ratio <= 0.0:
        # Change the direction if we have hit the start or end of the path
        speed *= -1.0
    # Keep moving the aim bar along the path
    aim_bar_path.progress_ratio += speed * speed_multiplier * delta
