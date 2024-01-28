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
const speed_change : float = 0.05
var current_round : int = 1
var is_paused : bool = false
var show_tutorials : bool = true

# Attention Meter
var attention_meter = Timer.new()
const ATTENTION_METER_MAX : float = 30
enum AttentionChange {BAD = -5, OK = 5, GOOD = 7, GREAT = 10}

# SFX
@onready var pause_sfx : AudioStream = load("res://assets/audio/sfx/PauseAndResume/Pause.mp3")
@onready var resume_sfx : AudioStream = load("res://assets/audio/sfx/PauseAndResume/Resume.mp3")
@onready var cheering : AudioStream = load("res://assets/audio/sfx/BooingAndCheering/CrowdCheering.mp3")
@onready var booing : AudioStream = load("res://assets/audio/sfx/BooingAndCheering/CrowdBooing.mp3")

func _ready():
	attention_meter.wait_time = ATTENTION_METER_MAX
	attention_meter.one_shot = true
	add_child(attention_meter)
	reset()


func reset() -> void:
	attention_meter.start(ATTENTION_METER_MAX)
	score = 0
	Engine.time_scale = 1.0
	current_round = 1
	score_multipier = 1
	is_paused = false
	get_tree().paused = false


func increase_score() -> void:
	score += SCORE_INCREASE * score_multipier


func next_round() -> void:
	current_round += 1
	increase_speed()
	print("ROUND = " + str(current_round) + " SPEED = " + str(Engine.time_scale))


func increase_speed() -> void:
	Engine.time_scale += speed_change


# Pauses the game, including the background music.
func pause() -> void:
	is_paused = true
	get_tree().paused = true
	SoundManager.pause_music()
	if pause_sfx:
		SoundManager.play_ui_sound(pause_sfx)


# Resumes the game, including the background music.
func resume() -> void:
	is_paused = false
	get_tree().paused = false
	if resume_sfx:
		SoundManager.play_ui_sound(resume_sfx)
	SoundManager.resume_music()


# Halts gameplay while a popup window is shown, but does not play pause/resume
# sound effects
func popup_window(is_showing : bool) -> void:
	is_paused = is_showing
	get_tree().paused = is_showing


# Updates the attention meter given the player's performance in a mini-game.
func update_attention_meter(rating : MiniGame.Rating):
	# Calculate the change based on the given rating
	var change = 0
	match rating:
		MiniGame.Rating.FAILED: 	change = AttentionChange.BAD
		MiniGame.Rating.AVERAGE: 	change = AttentionChange.OK
		MiniGame.Rating.GOOD: 		change = AttentionChange.GOOD
		MiniGame.Rating.PERFECT: 	change = AttentionChange.GREAT

	if change > 0:
		SoundManager.play_sound(cheering)
	else:
		SoundManager.play_sound(booing)

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
