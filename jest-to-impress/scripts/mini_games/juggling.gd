extends MiniGame

# juggling.gd: This script contains the code for the juggling mini-game.
#
# Author(s): Adam Goodyear

var has_clicked : bool = false
var clickable : bool = false

func _ready():
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true


func _process(_delta):
	if clickable:
		if Input.is_action_just_pressed("LeftClick"):
			has_clicked = true
			GamestateManager.update_attention_meter(Rating.GOOD)


func toggle_clickable():
	if not clickable:
		has_clicked = false
		clickable = true
	else:
		if has_clicked:
			clickable = false
		else:
			GamestateManager.update_attention_meter(Rating.FAILED)
			clickable = false


func _on_finished(anim_name):
	on_finished()
