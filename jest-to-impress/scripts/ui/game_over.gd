extends Node

# game_over.gd: This script displays the player's final score on game over and
#               responding to the player clicking any of the navigation buttons.
#
# Author(s): Tessa Power

@onready var final_score_label = get_node("Content/FinalScore")

func _ready() -> void:
	final_score_label.text += "\n" + str(GamestateManager.score)


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_return_to_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
