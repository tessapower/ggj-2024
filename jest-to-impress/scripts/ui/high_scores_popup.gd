extends Node

# high_scores_popup.gd: Reads the high scores and creates a list to display in
#                       the popup on the start menu.
#
# Author(s): Tessa Power

const EMPTY_TEXT : String = "[center][b]High Scores[/b][/center]
[center]There are no high scores yet.[/center]"

func _ready():
	var list = scores_to_list(HighScoresManager.high_scores)
	$Submenu/Content/ScrollContainer/TextContent.set_text(list)

func scores_to_list(scores : Array) -> String:
	if scores.is_empty(): return EMPTY_TEXT

	var list = ""
	for score in scores:
		list += score[0] + " \t " + str(score[1]) + "\n"
	return list
