extends Node2D

# mini_game.gd: This script contains the base code for a mini-game.
#
# Author(s): Adam Goodyear

@export var tutorialText: String = "[center][b] TITLE [/b][/center][center] DESCRIPTION [/center]"

signal failure
signal finish
const TUTORIAL = preload("res://scenes/ui/submenu.tscn")
var tutorialInstance : Node
	
func show_tutorial():
	tutorialInstance = TUTORIAL.instantiate()
	tutorialInstance.set_text(tutorialText)
	tutorialInstance.hide()
	tutorialInstance.connect("close_requested", self.hide_tutorial)
	add_child(tutorialInstance)
	GamestateManager.pause()
	tutorialInstance._on_show()
	
func hide_tutorial():
	GamestateManager.resume()

func finished():
	emit_signal("finish")


func failed():
	emit_signal("failure")
