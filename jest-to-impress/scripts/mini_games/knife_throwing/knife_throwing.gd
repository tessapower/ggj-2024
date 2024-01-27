extends MiniGame

# knife_throwing.gd: This script contains the code for the knife-throwing
#                    mini-game.
#
# Author(s): Tessa Power

# Mini-game State
var current_round = 1
const MAX_ROUNDS = 3
var n_missed = 0
const MAX_MISSED = 2

# Aim Bar
@onready var aim_bar = get_node('AimPath/PathFollow/AimBar')
@onready var aim_bar_path = get_node("AimPath/PathFollow")

# Speed
var direction = 1.0 # corresponds to going right
var speed = 0.5
var did_click = false

# Ranges
enum Ranges {MISSED = 0, AVERAGE, GOOD, PERFECT}
@onready var missed = get_node("Missed")
@onready var average = get_node("Average")
@onready var good = get_node("Good")
@onready var perfect = get_node("Perfect")

func _ready() -> void:
	reset()
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true


# Reset the state of the mini-game
func reset() -> void:
	current_round = 1
	n_missed = 0


func _process(delta) -> void:
	# Check if user did click already, in which case we don't want the bar to
	# keep moving so we return early
	if did_click: return

	# Check how far along the path the aim bar is
	var progress_ratio = aim_bar_path.progress_ratio
	if progress_ratio >= 1.0 or progress_ratio <= 0.0:
		# Change the direction if we have hit the start or end of the path
		direction *= -1.0
	# Keep moving the aim bar along the path
	aim_bar_path.progress_ratio += speed * direction * delta


func _unhandled_input(event) -> void:
	# Respond to mouse clicks anywhere in the window except for buttons
	if event.is_action_pressed("LeftClick"):
		did_click = true
		# TODO: remove this in favor of waiting on the animation
		await get_tree().create_timer(1.0).timeout

		update_attention_meter()

		# Check whether the player won, lost, or can continue to the next round
		if current_round == MAX_ROUNDS or n_missed == MAX_MISSED:
			# TODO: Display game won animation?
			# TODO: Play game won sound?
			on_finished()
		else:
			next_round()


func update_attention_meter() -> void:
	var r = get_overlapping_range()
	# Either update score or increased the missed count
	if r == Ranges.MISSED:
		# TODO: Pause for a second to show some poor knife-throwing animation
		# TODO: play sfx
		n_missed += 1
	#else:
		# TODO: Pause for a second to show some knife-throwing animation
		# and a change to the score
		# TODO: play sfx

	GamestateManager.update_attention_meter(r)


# Returns the range that the aim bar is overlapping
func get_overlapping_range() -> Ranges:
	var overlapping = aim_bar.get_overlapping_areas()
	if overlapping.has(perfect):
		return Ranges.PERFECT
	elif overlapping.has(good):
		return Ranges.GOOD
	elif overlapping.has(average):
		return Ranges.AVERAGE
	return Ranges.MISSED


func next_round() -> void:
	# Increase the round number
	current_round += 1
	# Reset the aim bar position
	# TODO: reset to either start or end, chosen at random
	aim_bar_path.progress_ratio = 0.0
	# Update the ranges
	did_click = false
