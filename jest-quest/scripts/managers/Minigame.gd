extends Node2D

var isDone:bool = false;
signal failure
signal finish
	
func finished():
	emit_signal("finish")
func failed():
	emit_signal("failure")
