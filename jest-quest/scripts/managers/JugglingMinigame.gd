extends "res://scenes/managers/Minigame.gd"

var hasClicked : bool = false
var clickable : bool = false
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			hasClicked = true
			score += 1
			print("Hit! = " + str(score))
	else:
		if Input.is_action_just_pressed("LeftClick"):
			failed()
			score -= 1
			print("Missclick = " + str(score))
			
func toggleClickable():
	if clickable == false:
		hasClicked = false
		clickable = true
	else:
		if hasClicked:
			clickable = false
		else:
			failed()
			score -= 1
			clickable = false
			print("Missed = " + str(score))
