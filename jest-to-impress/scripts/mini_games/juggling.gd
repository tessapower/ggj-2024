extends "res://scripts/mini_games/mini_game.gd"

# juggling.gd: This script contains the code for the juggling mini-game.
#
# Author(s): Adam Goodyear

var has_clicked : bool = false
var clickable : bool = false
var score = 0
static var tutorial = true

func _ready():
	if tutorial:
		show_tutorial()
		tutorial = false

func _process(_delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			has_clicked = true
			score += 1
			print("Hit! = " + str(score))
	else:
		if Input.is_action_just_pressed("LeftClick"):
			failed()
			score -= 1
			print("Missclick = " + str(score))


func toggle_clickable():
	if not clickable:
		has_clicked = false
		clickable = true
	else:
		if has_clicked:
			clickable = false
		else:
			failed()
			score -= 1
			clickable = false
			print("Missed = " + str(score))
