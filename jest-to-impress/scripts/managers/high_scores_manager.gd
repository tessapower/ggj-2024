extends Node

## high_scores_manager.gd: Manages loading and saving high scores for the game.
##
## Author(s): Tessa Power

# High Scores Data
var high_scores: Array = []
const HS_FILEPATH = "user://high_scores.tres"
var high_scores_data = HighScores.new()
const MAX_SCORES = 10

func _ready() -> void:
	load_from_disk()
	sort_high_scores()


# Update the list of high scores, which are kept in sorted order from highest
# to lowest.
func update_high_scores(player_name : String, high_score : int) -> void:
	high_scores.append([player_name, high_score])
	sort_high_scores()


# Sorts the high scores in descending order.
func sort_high_scores() -> void:
	# Create a deep copy of the high scores
	var sorted = high_scores.duplicate(true)
	# Sort the high scores in descending order by comparing the scores
	sorted.sort_custom(func(a, b): return a[1] > b[1])
	# Only keep the top 10 high scores
	sorted.slice(0, MAX_SCORES, 1, true)
	high_scores = sorted.duplicate(true)


# Saves the high scores to disk. This function should ideally only be called
# right before exiting the game (using _exit_tree()) to avoid too many costly
# writes to disk.
func save_to_disk() -> void:
	ResourceSaver.save(high_scores_data, HS_FILEPATH)


# Returns whether the given score is considered a high score. This function
# should ideally be used to assess whether or not to show the high score name
# entry after the game ends.
func is_high_score(score : int) -> bool:
	# Compare the given score to the lowest high score
	return score >= high_scores.back()[1] if not high_scores.is_empty() else true


# Loads the high scores from disk. This function should ideally only be called
# once at start up to avoid costly reads from disk and more importatnly
# overwriting any new high scores achieved while the game is running.
func load_from_disk():
	if FileAccess.file_exists(HS_FILEPATH):
		high_scores_data = ResourceLoader.load(HS_FILEPATH).duplicate(true)
		high_scores = high_scores_data.high_scores
		# ⚠️ FOR DEVELOPMENT PURPOSES ONLY! ⚠️
		# Uncomment this to clear highscores.
		#high_scores.clear()
	else:
		printerr("No save file found at path!")
		print("Creating new save file...")
		save_to_disk()


func _exit_tree() -> void:
	save_to_disk()
