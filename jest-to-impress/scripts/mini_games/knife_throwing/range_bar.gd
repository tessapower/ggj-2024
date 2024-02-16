class_name RangeBar extends TextureRect

## range_bar.gd: This script contains the code for for the range bars used in the
##               knife-throwing mini-game.
##
## Author(s): Tessa Power

@onready var missed = get_node("Missed")
@onready var average = get_node("Average")
@onready var good = get_node("Good")
@onready var perfect = get_node("Perfect")

enum Ranges {MISSED = 0, AVERAGE, GOOD, PERFECT}
var current_range = Ranges.MISSED

func _on_area_entered(_area, range_entered):
	match range_entered:
		"missed":
			current_range = Ranges.MISSED
		"average":
			current_range = Ranges.AVERAGE
		"good":
			current_range = Ranges.GOOD
		"perfect":
			current_range = Ranges.PERFECT
