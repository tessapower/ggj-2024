extends "res://scripts/mini_games/mini_game.gd"

# juggling.gd: This script contains the code for the juggling mini-game.
#
# Author(s): Adam Goodyear

var has_clicked : bool = false
var clickable : bool = false
var score = 0

func _process(_delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			has_clicked = true
			score += 1
			print("Hit! = " + str(score))

func toggle_clickable():
	if not clickable:
		has_clicked = false
		clickable = true
	else:
		if has_clicked:
			clickable = false
		else:
			score -= 1
			clickable = false
			print("Missed = " + str(score))

func finish_juggling():
	if score < -1:
		finished(0)
	elif score < 1:
		finished(1)
	elif score < 3:
		finished(2)
	else:
		finished(3)
	
