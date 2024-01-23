extends Node2D

# TODO: possibly remove this if it is unused?
var is_done : bool = false;

signal failure
signal finish

func finished():
	emit_signal("finish")


func failed():
	emit_signal("failure")
