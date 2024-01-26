extends Node2D

# mini_game.gd: This script contains the base code for a mini-game.
#
# Author(s): Adam Goodyear


# TODO: possibly remove this if it is unused?
var is_done : bool = false;

signal failure
signal finished

func finish():
	emit_signal("finished")
