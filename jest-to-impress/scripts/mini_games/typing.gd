extends "res://scripts/mini_games/mini_game.gd"

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

var current_joke : String = ""
var word_index : int = 0
var rng = RandomNumberGenerator.new()

# Player's input
var player_input : String = ""
var word_text_edit : TextEdit

func _ready():
	start_new_joke()
	$Progress.max_value = $Timer.wait_time


func _process(_delta):
	$Progress.value = $Timer.time_left


func start_new_joke():
	$Timer.start()
	player_input = ""
	word_index = 0
	current_joke = JOKES.keys().pick_random()

	$setup.text.set_text("[center]" + current_joke + "[/center]")
	update_sentence_label()


func update_sentence_label():
	$punchline.text = ""
	if player_input.length() > 0:
		$punchline.text += "[center][color=red]"
		for i in range(0,player_input.length()):
			$punchline.text += current_joke[i]
		$punchline.text += "[/color]"
		for i in range(player_input.length(), current_joke.length()):
			$punchline.text += current_joke[i]
		$punchline.text += "[/center]"
	else:
		$punchline.text = "[center]" + current_joke + "[/center]"


func _input(event):
	if event is InputEventKey:
		var key : int = event.keycode
		if event.is_pressed():
			on_key_pressed(String.chr(key))


func on_key_pressed(key: String):
	print("Does " + key + " == " + current_joke[word_index].capitalize())
	if key == " ":
		if current_joke[word_index] == " ":
			player_input += key
			if word_index < current_joke.length()-2:
				word_index += 1
				update_sentence_label()
	elif current_joke[word_index].capitalize() == key.capitalize():
		player_input += key
		if word_index < current_joke.length()-1:
			word_index += 1
		update_sentence_label()

	print("Player Input: " + player_input)
	if player_input.capitalize() == current_joke.capitalize():
		on_sentence_complete()


func evaluate_finish() -> int:
	var finishTime = $Timer.time_left
	if finishTime > ($Timer.wait_time / 2):
		return 3
	elif finishTime > ($Timer.wait_time / 4):
		return 2
	else:
		return 1


func on_sentence_complete():
	print("WORD DONE")
	var evaluation = evaluate_finish()
	GamestateManager.calculate_attention(evaluation)
	on_finished()


func _on_timer_timeout():
	GamestateManager.calculate_attention(0)
	on_finished()
