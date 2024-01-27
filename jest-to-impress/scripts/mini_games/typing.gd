extends "res://scripts/mini_games/mini_game.gd"

# typing.gd: This script contains the code for the joke typing mini-game.
#
# Author(s): Adam Goodyear, Tessa Power

const JOKES : Dictionary = {
	"What do sweet potatoes wear to bed?": "yammies",
	"What do you call fake noodles?": "impastas",
	"How does the man in the moon get his hair cut?": "eclipse it",
	"What do fish say when they hit a concrete wall?": "dam",
	"What do you call a guy who’s had too much to drink?": "a cab",
	"What are blunt pencils?": "pointless",
	"‘I have a split personality,’ said Tom,": "being frank",
	"What do you call a snail that isn’t moving?": "an escar-stay",
	"The past, the present and the future all walk into a bar.": "it was tense",
	"How did doctors describe the condition of the man who ate six whole horses?": "stable",
	"How does Satan like his pasta?": "al dante"
}

var current_punchline : String = ""
var player_input : String = ""

func _ready():
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true

	start_new_joke()
	$Progress.max_value = $Timer.wait_time


func _process(_delta):
	$Progress.value = $Timer.time_left


func start_new_joke():
	$Timer.start()
	player_input = ""
	var current_joke = JOKES.keys().pick_random()
	current_punchline = JOKES.get(current_joke)

	$Setup.text = "[center]" + current_joke + "[/center]"
	update_punchline_label()


func update_punchline_label():
	# Clear the text from the punchline label
	$Punchline.text = ""

	if player_input.is_empty():
		# Player hasn't typed anything yet, display the punchline and return
		$Punchline.text = "[center]" + current_punchline + "[/center]"
		return

	# Player has correctly typed some of the punchline
	# Add the characters the player has typed, highlighted in red
	$Punchline.text += "[center][color=red]"
	$Punchline.text += player_input
	$Punchline.text += "[/color]"

	# Add the rest of the punchline greyed out
	$Punchline.text += current_punchline.substr(player_input.length())
	$Punchline.text += "[/center]"


func _input(event):
	if event is InputEventKey and event.is_pressed():
		on_key_pressed(String.chr(event.keycode))


func on_key_pressed(key: String):
	var attempted_input = player_input + key.to_lower()

	# If the start of the punchline matches the player's attempted input,
	# then update the player input and the punchline label
	if current_punchline.to_lower().begins_with(attempted_input):
		player_input = attempted_input
		update_punchline_label()

	# If the strings match exactly, player is done
	if current_punchline.nocasecmp_to(attempted_input) == 0:
		on_sentence_complete()


func evaluate_finish() -> Rating:
	var finish_time = $Timer.time_left
	if finish_time > ($Timer.wait_time / 2):
		return Rating.PERFECT
	elif finish_time > ($Timer.wait_time / 4):
		return Rating.GOOD
	else:
		return Rating.AVERAGE


func on_sentence_complete():
	var evaluation = evaluate_finish()
	GamestateManager.update_attention_meter(evaluation)
	on_finished()


func _on_timer_timeout():
	GamestateManager.update_attention_meter(Rating.FAILED)
	on_finished()
