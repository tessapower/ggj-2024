extends MiniGame

# juggling.gd: This script contains the code for the juggling mini-game.
#
# Author(s): Adam Goodyear

var has_clicked : bool = false
var clickable : bool = false
var score = 0

func _ready():
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true


func _process(_delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			has_clicked = true
			score += 1
			print("Hit! = " + str(score))
	else:
		if Input.is_action_just_pressed("LeftClick"):
			failed(Rating.FAILED)
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
			failed(Rating.FAILED)
			score -= 1
			clickable = false
			print("Missed = " + str(score))

