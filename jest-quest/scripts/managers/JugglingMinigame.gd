extends Node2D

var clickable = false
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			score += 1
			print("Hit! = " + str(score))
	else:
		if Input.is_action_just_pressed("LeftClick"):
			score -= 1
			print("Miss = " + str(score))
			
func toggleClickable():
	clickable = !clickable
