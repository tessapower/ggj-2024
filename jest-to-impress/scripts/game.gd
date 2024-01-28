extends Node2D

# game.gd: This script controls the main game scene, and is used to load/unload
#          the mini-games as well as transition from the game to game over
#          scene.
#
# Author(s): Adam Goodyear, Tessa Power

#King States
const king_asleep = preload("res://assets/King_Asleep.png")
const king_bored = preload("res://assets/King_Bored.png")
const king_laughing = preload("res://assets/King_Laughing.png")
const king_neutral = preload("res://assets/King_Neutral.png")
const king_pleased = preload("res://assets/King_Pleased.png")

# TODO: Maybe consider adding this to the game scene
const attention_meter = preload("res://scenes/ui/attention_meter.tscn")
var attention_meter_instance : Node

# Mini-games
var mini_games : Array = []
const JUGGLING = preload("res://scenes/mini_games/juggling.tscn")
const KNIFE_THROWING = preload("res://scenes/mini_games/knife_throwing/knife_throwing.tscn")
const TYPING = preload("res://scenes/mini_games/typing.tscn")
const SWORD_SWALLOWING = preload("res://scenes/mini_games/sword_swallowing.tscn")

# Rounds
var round : Array = []

var mini_game_instance : Node = null
var played_games : Array = []
var current_idx = 0

# Background Music & SFX
@export_category("Background Music")
@export_file var background_music_file
var background_music : AudioStream
const BG_MUSIC_VOLUME : float = -5.0

func _ready():
	# TODO: Maybe consider adding the attention meter to the game scene
	attention_meter_instance = attention_meter.instantiate()
	attention_meter_instance.connect("attentionOut", GamestateManager.end_game)
	add_child(attention_meter_instance)
	
	$curtains.connect("curtainsDown", self.on_curtains_down)

	# TODO: add mini-games here!
	mini_games.append(JUGGLING)
	mini_games.append(KNIFE_THROWING)
	mini_games.append(TYPING)
	mini_games.append(SWORD_SWALLOWING)
	mini_games.shuffle()
	generate_round()
	load_mini_game(current_idx)
	GamestateManager.reset()

	# Music
	if background_music_file:
		background_music = load(background_music_file)
		SoundManager.play_music_at_volume(background_music, BG_MUSIC_VOLUME)

func _process(delta):
	if GamestateManager.attention_meter.time_left > (GamestateManager.ATTENTION_METER_MAX / 5 * 4):
		$CanvasLayer/king.texture = king_laughing
	elif GamestateManager.attention_meter.time_left > (GamestateManager.ATTENTION_METER_MAX / 5 * 3):
		$CanvasLayer/king.texture = king_pleased
	elif GamestateManager.attention_meter.time_left > (GamestateManager.ATTENTION_METER_MAX / 5 * 2):
		$CanvasLayer/king.texture = king_neutral
	elif GamestateManager.attention_meter.time_left > (GamestateManager.ATTENTION_METER_MAX / 5):
		$CanvasLayer/king.texture = king_bored
	else:
		$CanvasLayer/king.texture = king_asleep

func _unhandled_input(event) -> void:
	if event.is_action_pressed("Pause"):
		$PausePopup.show()
		GamestateManager.pause()

func generate_round():
	round.clear()
	mini_games.shuffle()
	for i in range(0,3):
		round.append(mini_games[i])

# Loads the mini-game at the given index and hooks it up to the appropriate
# callback functions
func load_mini_game(idx : int) -> void:
	var mini_game = round[idx]
	mini_game_instance = mini_game.instantiate()
	mini_game_instance.connect("finished", self.on_finished)
	add_child(mini_game_instance)


# Unloads the current mini-game and disconnects the callback functions
func unload_mini_game() -> void:
	# We assume that the most recently added child is our mini-game
	mini_game_instance.disconnect("finished", self.on_finished)
	mini_game_instance.queue_free()


# A callback function intended to be called by a mini-game when the player loses
func on_failure() -> void:
	# Decide whether or not to continue the game based on the attention meter
	if GamestateManager.is_game_over():
		# TODO: display some game over animation?
		# TODO: Stop the music
		get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
	else:
		next_mini_game()


# A callback function intended to be called by a mini-game when the player wins
func on_finished() -> void:
	# TODO: display something or some kind of animation?
	# TODO: maybe wait a second so the player has a bit of a break
	# Load the next mini-game
	GamestateManager.increase_score()
	next_mini_game()


# Loads the next mini-game, if there is one, otherwise starts playing again from
# the beginning of the list
func next_mini_game() -> void:
	$curtains._beginAnimation()

func on_curtains_down() -> void:
	# Remove current mini-game from the scene
	unload_mini_game()
	# Move on to the next mini-game, if there is one, otherwise start a new
	# round from the beginning with increased speed!
	current_idx += 1
	if current_idx == round.size():
		generate_round()
		GamestateManager.next_round()
		current_idx = 0

	# Load the mini-game at the new index
	load_mini_game(current_idx)
