class_name MiniGame extends Node2D

# mini_game.gd: This script contains the base code for a mini-game.
#
# Author(s): Adam Goodyear, Tessa Power

signal failure
signal finished

@onready var tutorial : Submenu = get_node("Tutorial")

enum Rating {FAILED = 0, AVERAGE, GOOD, PERFECT}

# SFX
@onready var good_sound: AudioStream = load("res://assets/audio/sfx/player_feedback/done_something_right.mp3")
@onready var bad_sound: AudioStream = load("res://assets/audio/sfx/player_feedback/done_something_wrong.mp3")

func show_tutorial() -> void:
	tutorial._on_show()
	GamestateManager.pause_gameplay(true)


func hide_tutorial() -> void:
	GamestateManager.pause_gameplay(false)


func play_success_sound() -> void:
	SoundManager.play_sound(good_sound)


func play_failed_sound() -> void:
	SoundManager.play_sound(bad_sound)


func on_finished() -> void:
	# TODO: Display game won animation?
	# TODO: Play game won sound?
	GamestateManager.increase_score()
	emit_signal("finished")


# TODO: check where this is used, remove if unused
func on_failed() -> void:
	# TODO: Display game lost animation?
	# TODO: Play game lost sound?
	emit_signal("failure")

