extends "res://scripts/mini_games/mini_game.gd"

var game_name = "Knife-throwing"
var game_description = "Throw knives at the target. The closer to the center, the more points you get."

# Aim Bar
@onready var aim_bar = get_node('AimPath/PathFollow/AimBar')
@onready var aim_bar_path = get_node("AimPath/PathFollow")

@export var speed_multiplier = 1.0
var speed = 0.2
enum RANGES {MISSED = 0, AVERAGE, GOOD, PERFECT}
@onready var missed = get_node("Missed")
@onready var average = get_node("Average")
@onready var good = get_node("Good")
@onready var perfect = get_node("Perfect")
@onready var current_range = RANGES.MISSED


func _process(delta) -> void:
    # Check how far along the path the aim bar is
    var progress_ratio = aim_bar_path.progress_ratio
    if progress_ratio >= 1.0 or progress_ratio <= 0.0:
        # Change the direction if we have hit the start or end of the path
        speed *= -1.0
    # Keep moving the aim bar along the path
    aim_bar_path.progress_ratio += speed * speed_multiplier * delta


# Returns the range that the aim bar is overlapping
func get_overlapping_range() -> RANGES:
    var overlapping = aim_bar.get_overlapping_areas()
    if overlapping.has(perfect):
        return RANGES.PERFECT
    elif overlapping.has(good):
        return RANGES.GOOD
    elif overlapping.has(average):
        return RANGES.AVERAGE
    return RANGES.MISSED

