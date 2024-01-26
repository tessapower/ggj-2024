extends MiniGame

# juggling.gd: This script contains the code for the juggling mini-game.
#
# Author(s): Adam Goodyear

var has_clicked : bool = false
var clickable : bool = false
var score = 0
# TODO: track how the player is going and apply a rating based

func _ready():
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true


func _process(_delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			has_clicked = true
			GamestateManager.calculate_attention(1)
			print("Hit! = " + str(score))

func toggle_clickable():
	if not clickable:
		has_clicked = false
		clickable = true
	else:
		if has_clicked:
			clickable = false
		else:
			GamestateManager.calculate_attention(0)
			clickable = false
			print("Missed = " + str(score))

func finish_juggling():
	finish()

