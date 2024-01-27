extends Node2D

# gamestate_manager.gd: This is a global node that is autoloaded and can be
#                       accessed anywhere in the game. It keeps track of the
#                       current mini-game, the player's score, and whether the
#                       game is paused. It also contains functions to register
#                       mini-games, pause the game, resume the game, and reset
#                       the game to the default state.
#
# Author(s): Adam Goodyear, Tessa Power

# Player Score
var score : int = 0
const SCORE_INCREASE : int = 1
var score_multipier : int = 1

# Game state
var speed : float = 1.0
const speed_change : float = 0.5
var current_round : int = 1
var is_paused : bool = false
var show_tutorials : bool = true

# Attention Meter
var attention_meter = Timer.new()
const ATTENTION_METER_MAX : float = 30
enum AttentionChange {BAD = -5, OK = 5, GOOD = 7, GREAT = 10}

func _ready():
	attention_meter.wait_time = ATTENTION_METER_MAX
	attention_meter.one_shot = true
	add_child(attention_meter)
	reset()


func reset() -> void:
	attention_meter.start(ATTENTION_METER_MAX)
	score = 0
	speed = 1.0
	current_round = 1
	score_multipier = 1


func increase_score() -> void:
	score += SCORE_INCREASE * score_multipier


func next_round() -> void:
	current_round += 1
	increase_speed()


func increase_speed() -> void:
	speed += speed_change


# Pauses the game, including the background music.
func pause() -> void:
	is_paused = true
	get_tree().paused = true
	SoundManager.pause_music()


# Resumes the game, including the background music.
func resume() -> void:
	is_paused = false
	get_tree().paused = false
	SoundManager.resume_music()


# Updates the attention meter given the player's performance in a mini-game.
func update_attention_meter(rating : MiniGame.Rating):
	# Calculate the change based on the given rating
	var change = 0
	match rating:
		MiniGame.Rating.FAILED: 	change = AttentionChange.BAD
		MiniGame.Rating.AVERAGE: 	change = AttentionChange.OK
		MiniGame.Rating.GOOD: 		change = AttentionChange.GOOD
		MiniGame.Rating.PERFECT: 	change = AttentionChange.GREAT

	# Add the change to the time left on the attention meter
	var new_val = attention_meter.time_left + change

	# Respond to the change appropriately, ending the game if attention is zero
	if new_val > ATTENTION_METER_MAX:
		attention_meter.start(ATTENTION_METER_MAX)
		score_multipier += 1
	elif new_val <= 0:
		end_game()
	else:
		attention_meter.start(new_val)
		score_multipier = 1


func end_game():
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
