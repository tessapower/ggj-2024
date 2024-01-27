class_name MiniGame extends Node2D

# mini_game.gd: This script contains the base code for a mini-game.
#
# Author(s): Adam Goodyear, Tessa Power

var has_played : bool = false
@onready var tutorial : Submenu = get_node("Tutorial")

enum Rating {FAILED = 0, AVERAGE, GOOD, PERFECT}

signal failure
signal finished

func show_tutorial() -> void:
	tutorial._on_show()
	GamestateManager.pause()


func hide_tutorial() -> void:
	GamestateManager.resume()


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

