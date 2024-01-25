extends "res://scripts/mini_games/mini_game.gd"

var possibleJokes : Array = ["What do sweet potatoes wear to bed?", "What do you call fake noodles?", "How does the man in the moon get his hair cut?", "What do fish say when they hit a concrete wall?", "What do you call a guy who’s had too much to drink?", "What are blunt pencils?", "‘I have a split personality,’ said Tom,", "What do you call a snail that isn’t moving?", "The past, the present and the future all walk into a bar.", "How did doctors describe the condition of the man who ate six whole horses?", "How does Satan like his pasta?"]
var punchline : Array = ["yammies", "impastas", "eclipse it", "dam", "a cab", "pointless", "being frank", "an escar-stay", "it was tense", "stable", "al dante"]
var currentJoke : String = ""
var currentIndex : int = 0

var wordIndex : int = 0

var rng = RandomNumberGenerator.new()
# Player's input
var playerInput : String = ""

var wordTextEdit : TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	start_new_joke()
	$Progress.max_value = $Timer.wait_time
	
func _process(delta):
	$Progress.value = $Timer.time_left
	
func start_new_joke():
	$Timer.start()
	playerInput = ""
	wordIndex = 0
	
	currentIndex = rng.randi_range(0, punchline.size()-1)
	$setup.text = "[center]" + possibleJokes[currentIndex] + "[/center]"
	currentJoke = punchline[currentIndex]
	update_sentence_label()

func update_sentence_label():
	$punchline.text = ""
	if playerInput.length() > 0:
		$punchline.text += "[center][color=red]"
		for i in range(0,playerInput.length()):
			$punchline.text += currentJoke[i]
		$punchline.text += "[/color]"
		for i in range(playerInput.length(), currentJoke.length()):
			$punchline.text += currentJoke[i]
		$punchline.text += "[/center]"
	else:
		$punchline.text = "[center]" + currentJoke + "[/center]"

func _input(event):
	if event is InputEventKey:
		var key : int = event.keycode
		if event.is_pressed():
			on_key_pressed(String.chr(key))
			
func on_key_pressed(key: String):
	print("Does " + key + " == " + currentJoke[wordIndex].capitalize())
	if key == " ":
		if currentJoke[wordIndex] == " ":
			playerInput += key
			if wordIndex < currentJoke.length()-2:
				wordIndex += 1
				update_sentence_label()
	elif currentJoke[wordIndex].capitalize() == key.capitalize():
		playerInput += key
		if wordIndex < currentJoke.length()-1:
			wordIndex += 1
		update_sentence_label()
	
	print("Player Input: " + playerInput)
	if playerInput.capitalize() == currentJoke.capitalize():
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
	finished(evaluation)
	start_new_joke()

func _on_timer_timeout():
	finished(0)
	start_new_joke()
