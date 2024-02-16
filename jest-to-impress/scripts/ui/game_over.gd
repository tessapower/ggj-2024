extends Node

## game_over.gd: This script displays the player's final score on game over and
##               responding to the player clicking any of the navigation buttons.
##
## Author(s): Tessa Power

@onready var final_score = get_node("Content/FinalScore")
@onready var new_high_score = get_node("Content/NewHighScore")

@export_file var background_music_file = null
var background_music : AudioStream
const BG_MUSIC_VOLUME : float = -5.0

# Sound Effects
@export_file var click_sound_file = null
var click_sound : AudioStream = null

func _ready() -> void:
	# Start playing music
	if background_music_file:
		background_music = load(background_music_file)
		SoundManager.play_music_at_volume(background_music, BG_MUSIC_VOLUME)

	# Set up SFX
	if click_sound_file:
		click_sound = load(click_sound_file)

	# Show the player's final score
	var score = GamestateManager.score
	# Update the text to display the final score
	final_score.text += str(score)
	# Check if we got a high score
	if HighScoresManager.is_high_score(score) and score > 0:
		# TODO: Play some happy triumphant sound?
		# Show the new high score entry popup
		$HighScoreEntry.show()
	else:
		new_high_score.set_text("")


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_return_to_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	if click_sound:
		SoundManager.play_ui_sound(click_sound)
