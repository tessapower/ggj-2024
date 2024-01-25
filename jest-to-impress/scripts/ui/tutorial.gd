extends Node2D
var Titles = ["JUGGLING", "KNIFE THROWING", "JOKE TELLING"]
var Descriptions = [
"Wait for the countdown to end and when the jester catches a ball in both hands left click. The text on screen will flash red when you should click!",
"Throwing a knife is all about timing. Wait for the white bar to reach the green segment of the range then left click.", 
"Telling a good joke it all about timing. Quickly type out the greyed out punchline before time runs out!"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Control/RichTextLabel.text = "[center][b]" + "THIS IS WRONG" + "[/b][/center][center]" + "YOU SHOULDNT SEE THIS" + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_text(val : int):
	GamestateManager.pause()
	$CanvasLayer/Control.show()
	$CanvasLayer/Control/RichTextLabel.text = "[center][b]" + Titles[val] + "[/b][/center][center]" + Descriptions[val] + "[/center]"

func _on_button_button_down():
	$CanvasLayer/Control.hide()
	GamestateManager.resume()
