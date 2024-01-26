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
var show_tutorials : bool = true

# Game state
var speed : float = 1.0
const speed_change : float = 0.5
var attention_meter : float = 0.5
const attention_change : float = 0.1
var current_round : int = 1
var is_paused : bool = false

func _ready():
	reset()


func reset() -> void:
	score = 0
	speed = 1.0
	attention_meter = 0.5
	current_round = 1


func increase_score(points_won : int) -> void:
	score += points_won


func increase_attention_meter() -> void:
	attention_meter += attention_change


func decrease_attention_meter() -> void:
	attention_meter -= attention_change


func next_round() -> void:
	current_round += 1
	increase_speed()


func increase_speed() -> void:
	speed += speed_change


func is_game_over() -> bool:
	return attention_meter <= 0.0


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
