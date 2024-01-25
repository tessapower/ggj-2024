extends Node2D

# game.gd: This script controls the main game scene, and is used to load/unload
#          the mini-games as well as transition from the game to game over
#          scene.
#
# Author(s): Adam Goodyear, Tessa Power

# Mini-games
var mini_games : Array = []
var current_idx = 0
const attention_meter = preload("res://scenes/ui/attentionMeter.tscn")
var attention_meter_instance : Node
var attention_meter_max : float = 30

const JUGGLING = preload("res://scenes/mini_games/juggling.tscn")
const KNIFE_THROWING = preload("res://scenes/mini_games/knife_throwing/knife_throwing.tscn")
const TYPING = preload("res://scenes/mini_games/typingMinigame.tscn")
var mini_game_instance : Node = null

func _ready():
	attention_meter_instance = attention_meter.instantiate()
	attention_meter_instance.set_max_attention(attention_meter_max)
	attention_meter_instance.connect("attentionOut", self.end_game)
	add_child(attention_meter_instance)
	
	# TODO: add mini-games here!
	mini_games.append(JUGGLING)
	mini_games.append(KNIFE_THROWING)
	mini_games.append(TYPING)
	load_mini_game(current_idx)


# Loads the mini-game at the given index and hooks it up to the appropriate
# callback functions
func load_mini_game(idx : int) -> void:
	var mini_game = mini_games[idx]
	mini_game_instance = mini_game.instantiate()
	mini_game_instance.connect("finish", self.on_finished)
	add_child(mini_game_instance)


# Unloads the current mini-game and disconnects the callback functions
func unload_mini_game() -> void:
	# We assume that the most recently added child is our mini-game
	mini_game_instance.disconnect("finish", self.on_finished)
	mini_game_instance.queue_free()


# A callback function intended to be called by a mini-game when the player loses
func on_failure() -> void:
	decrease_attention_meter(10)
	# Decide whether or not to continue the game based on the mood meter
	if attention_meter_instance.get_attention() < 0:
		end_game()
		# TODO: create a game over screen and load that
	else:
		print("Next mini-game!")
		next_mini_game()
		
# A callback function intended to be called by the game when the player runs out of attention
func end_game() -> void:
	print("ENDING GAME!")
	attention_meter_instance.set_attention(attention_meter_max)
	GamestateManager.reset()


# A callback function intended to be called by a mini-game when the player wins
func on_finished(arg1) -> void:
	# TODO: display something or some kind of animation?
	# TODO: maybe wait a second so the player has a bit of a break
	# Load the next mini-game
	if arg1 == 0:
		on_failure()
	elif arg1 == 1:
		increase_score(5)
	elif arg1 == 2:
		increase_score(7)
	elif arg1 == 3:
		increase_score(10)
		
	print("SCORE = " + str(GamestateManager.score))

	next_mini_game()


# Loads the next mini-game, if there is one, otherwise starts playing again from
# the beginning of the list
func next_mini_game() -> void:
	# Remove current mini-game from the scene
	unload_mini_game()

	# Move on to the next mini-game, if there is one, otherwise start a new
	# round from the beginning with increased speed!
	current_idx += 1
	if current_idx == mini_games.size():
		GamestateManager.next_round()
		current_idx = 0

	# Load the mini-game at the new index
	load_mini_game(current_idx)
	
func increase_score(increase : int) -> void:
	GamestateManager.increase_score(1)
	if attention_meter_instance.get_attention() + increase > attention_meter_max:
		set_attention_meter(attention_meter_max)
		GamestateManager.score_multipier += 1
	else:
		increase_attention_meter(increase)
		GamestateManager.score_multipier = 1
	
func increase_attention_meter(attention_change : int) -> void:
	var attention_meter_change = attention_meter_instance.get_attention() + attention_change
	attention_meter_instance.set_attention(attention_meter_change)

func decrease_attention_meter(attention_change : int) -> void:
	var attention_meter_change = attention_meter_instance.get_attention() - attention_change
	attention_meter_instance.set_attention(attention_meter_change)

func set_attention_meter(attention_change : int) -> void:
	attention_meter_instance.set_attention(attention_change)
