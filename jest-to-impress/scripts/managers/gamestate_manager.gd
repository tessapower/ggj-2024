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
var speed : float = 1.0
const speed_change : float = 0.5
var current_round : int = 1

# Game state
var is_paused : bool = false

func _ready():
	reset()

func reset() -> void:
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
