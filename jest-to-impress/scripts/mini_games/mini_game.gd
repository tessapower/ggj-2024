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


func finished(rating : Rating) -> void:
	# TODO: update the score and attention meter appopriately
	emit_signal("finish")


func failed(rating : Rating) -> void:
	# TODO: update the score and attention meter appopriately
	emit_signal("failure")

