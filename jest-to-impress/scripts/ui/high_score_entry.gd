extends Window

# high_score_entry.gd: A popup that allows players to enter their initials when
#                      they get a high score. Will handle adding the score to
#                      the leaderboard.
#
# Author(s): Tessa Power

@onready var text_entry = $Content/TextEntry
@onready var submit_button = $Content/Submit
@onready var error_msg = $Content/ErrorMessage
const ERROR_TEXT : String = "Please only use letters A - Z"
@onready var max_len = text_entry.max_length
@onready var regex = RegEx.new()

# Sound Effects
var cheering : AudioStream = load("res://assets/audio/sfx/BooingAndCheering/CrowdCheering.mp3")

func _ready():
	text_entry.clear()
	text_entry.grab_focus()

	submit_button.disabled = true
	# We only support entering alphabetic characters
	regex.compile("[^A-Za-z]")


func _on_line_edit_text_changed(new_text):
	# Don't do anything if the text field is empty
	if new_text == "":
		submit_button.disabled = true
		return

	# Enable the submit button if the new text isn't an empty string
	if is_text_valid(new_text):
		submit_button.disabled = false
		error_msg.set_text("")
	else:
		submit_button.disabled = true


func _on_line_edit_text_submitted(new_text):
	if new_text != "":
		if is_text_valid(new_text):
			# Add to the highscores
			if cheering:
				SoundManager.play_sound(cheering)
			HighScoresManager.update_high_scores(new_text, GamestateManager.score)
			# Clear the text entry field
			text_entry.clear()
			# Hide the popup window
			hide()
		else:
			error_msg.set_text(ERROR_TEXT)
	else:
		submit_button.disabled = true


func _on_submit_pressed():
	_on_line_edit_text_submitted(text_entry.text)


func is_text_valid(text) -> bool:
	var illegal_chars = regex.search(text)

	return false if illegal_chars else true
