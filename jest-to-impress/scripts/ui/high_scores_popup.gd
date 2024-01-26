extends Node

# high_scores_popup.gd: Reads the high scores and creates a list to display in
#                       the popup on the start menu.
#
# Author(s): Tessa Power

func _ready():
	var list = scores_to_list(HighScoresManager.high_scores)
	$Submenu/Content/TextContent.set_text(list)

func scores_to_list(scores : Array) -> String:
	if scores.is_empty(): return "There are no high scores."

	var list = ""
	for score in scores:
		list += score[0] + " \t " + str(score[1]) + "\n"
	return list
