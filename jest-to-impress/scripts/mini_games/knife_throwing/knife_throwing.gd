extends "res://scripts/mini_games/mini_game.gd"

# knife_throwing.gd: This script contains the code for the knife-throwing
#                    mini-game.
#
# Author(s): Tessa Power

# Mini-game Details
var game_name = "Knife-throwing"
var game_description = "Throw knives at the target. The closer to the center,
the more points you get."

# Mini-game State
var current_round = 1
const MAX_ROUNDS = 5
var n_missed = 0
const MAX_MISSED = 3
# TODO: eventually remove this in favor of updating the gamestate score
var score = 0

# Aim Bar
@onready var aim_bar = get_node('AimPath/PathFollow/AimBar')
@onready var aim_bar_path = get_node("AimPath/PathFollow")

# Speed
@export var speed_multiplier = 1.0
var speed = 0.2
var did_click = false

# Ranges
enum RANGES {MISSED = 0, AVERAGE, GOOD, PERFECT}
@onready var missed = get_node("Missed")
@onready var average = get_node("Average")
@onready var good = get_node("Good")
@onready var perfect = get_node("Perfect")
@onready var current_range = RANGES.MISSED


func _ready() -> void:
	reset()


# Reset the state of the mini-game
func reset() -> void:
	current_round = 1
	n_missed = 0
	score = 0


func _process(delta) -> void:
	# Check if user did click, return early if true
	if did_click: return

	# Check how far along the path the aim bar is
	var progress_ratio = aim_bar_path.progress_ratio
	if progress_ratio >= 1.0 or progress_ratio <= 0.0:
		# Change the direction if we have hit the start or end of the path
		speed *= -1.0
	# Keep moving the aim bar along the path
	aim_bar_path.progress_ratio += speed * speed_multiplier * delta


func _unhandled_input(event) -> void:
	# Respond to mouse clicks anywhere in the window except for buttons
	if event.is_action_pressed("LeftClick"):
		did_click = true
		var points_won = get_overlapping_range()

		# TODO: remove this in favor of waiting on the animation
		await get_tree().create_timer(1.0).timeout
		# Either update score or increased the missed count
		if points_won == 0:
			# TODO: Pause for a second to show some poor knife-throwing animation
			# TODO: play sfx
			n_missed += 1
			if n_missed == MAX_MISSED:
				game_lost()
				return
		else:
			# TODO: Pause for a second to show some knife-throwing animation
			# and a change to the score
			# TODO: play sfx
			# TODO: Eventually include a mood meter score multiplier?
			score += points_won
			print("new score: " + str(score))

		# Go to the next round
		if current_round == MAX_ROUNDS:
			game_won()
		else:
			next_round()


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


func next_round() -> void:
	# Increase the round number
	current_round += 1
	# Reset the aim bar position
	# TODO: reset to either start or end, chosen at random
	aim_bar_path.progress_ratio = 0.0
	# Update the ranges
	did_click = false


func game_lost() -> void:
	# Display game lost animation
	print("you lost :(")
	failed()


func game_won() -> void:
	# Display game won animation
	print("you won!")
	finished()
