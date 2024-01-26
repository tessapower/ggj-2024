extends Node2D

# gamestate_manager.gd: This is a global node that is autoloaded and can be
#                       accessed anywhere in the game. It keeps track of the
#                       current mini-game, the player's score, and whether the
#                       game is paused. It also contains functions to register
#                       mini-games, pause the game, resume the game, and reset
#                       the game to the default state.
#
# Author(s): Adam Goodyear, Tessa Power

# Player stats
var score : int = 0
var score_multipier : int = 1
var show_tutorials : bool = true

# Game state
var speed : float = 1.0
const speed_change : float = 0.5
var current_round : int = 1

var attention = Timer.new()
const ATTENTION_METER_MAX : float = 30

enum attention_levels {
	BAD = 0,
	OK = 1,
	GOOD = 2,
	GREAT = 3
}

var is_paused : bool = false

func _ready():
	attention.wait_time = ATTENTION_METER_MAX
	attention.one_shot = true
	add_child(attention)
	reset()

func reset() -> void:
	attention.start(ATTENTION_METER_MAX)
	score = 0
	speed = 1.0
	current_round = 1
	score_multipier = 1

func increase_score(points_won : int) -> void:
	score += points_won * score_multipier


func next_round() -> void:
	current_round += 1
	increase_speed()


func increase_speed() -> void:
	speed += speed_change


# Pauses the game, including the background music.
func pause() -> void:
	is_paused = true
	get_tree().paused = true
	#SoundManager.pause_music()


# Resumes the game, including the background music.
func resume() -> void:
	is_paused = false
	get_tree().paused = false
	#SoundManager.resume_music()

# Increases the time left on the attention meter
func increase_attention_meter(attention_change : int) -> void:
	if attention.time_left + attention_change > ATTENTION_METER_MAX:
		attention.start(ATTENTION_METER_MAX)
		score_multipier += 1
	else:
		attention.start(attention.time_left + attention_change)
		score_multipier = 1

# Decreases the time left on the attention meter
func decrease_attention_meter(attention_change : int) -> void:
	if attention.time_left - attention_change < 0:
		end_game()
	else:
		attention.start(attention.time_left - attention_change)
		score_multipier = 1

# Sets the attention meters values
func set_attention_meter(attention_change : int) -> void:
	attention.start(attention_change)

func calculate_attention(arg1 : attention_levels):
	match arg1:
		attention_levels.BAD:
			decrease_attention_meter(5)
		attention_levels.OK:
			increase_attention_meter(5)
		attention_levels.GOOD:
			increase_attention_meter(7)
		attention_levels.GREAT:
			increase_attention_meter(10)

func end_game():
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
