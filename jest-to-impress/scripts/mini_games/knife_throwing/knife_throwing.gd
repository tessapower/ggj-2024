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
static var has_played : bool = false

# Aim Bar
@onready var aim_bar = get_node('AimPath/PathFollow/AimBar')
@onready var aim_bar_path = get_node("AimPath/PathFollow")

# Speed
var direction = 1.0 # corresponds to going right
var speed = 0.5
var did_click = false

# Ranges
@onready var range_bars : Dictionary = {
	1: get_node("Round1"),
	2: get_node("Round2"),
	3: get_node("Round3")
}
var range_bar : Node = null

# SFX
@export_category("Sound Effect Files")
@export_file var sfx_file_1
@export_file var sfx_file_2
var sfx : Array[AudioStream] = []

func _ready() -> void:
	reset()
	# Load SFX
	if sfx_file_1:
		sfx.append(load(sfx_file_1))
	if sfx_file_2:
		sfx.append(load(sfx_file_2))

	# Show tutorial
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true
	else:
		hide_tutorial()


# Reset the state of the mini-game
func reset() -> void:
	current_round = 1
	range_bar = range_bars[current_round]
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
		# Play one of the sound effects
		SoundManager.play_sound_with_pitch(sfx.pick_random(), randf_range(0.8, 1.2))
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
	# Either update score or increased the missed count
	if range_bar.current_range == RangeBar.Ranges.MISSED:
		# TODO: Pause for a second to show some poor knife-throwing animation
		play_failed_sound()
		n_missed += 1
	else:
		# TODO: Pause for a second to show some knife-throwing animation
		# and a change to the score
		play_success_sound()

	GamestateManager.update_attention_meter(range_bar.current_range)


func next_round() -> void:
	# Increase the round number
	current_round += 1

	# Replace the current range bar with the range bar for the next round
	range_bar.queue_free()
	range_bar = range_bars[current_round]
	range_bar.visible = true

	# Reset the aim bar position
	# TODO: reset to either start or end, chosen at random
	aim_bar_path.progress_ratio = 0.0
	# Update the ranges
	did_click = false
