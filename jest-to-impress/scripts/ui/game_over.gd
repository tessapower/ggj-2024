extends Node

# game_over.gd: This script displays the player's final score on game over and
#               responding to the player clicking any of the navigation buttons.
#
# Author(s): Tessa Power

@onready var final_score = get_node("Content/FinalScore")
@onready var new_high_score = get_node("Content/NewHighScore")

func _ready() -> void:
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
