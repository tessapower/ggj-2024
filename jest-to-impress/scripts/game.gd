extends Node2D

## game.gd: This script controls the main game scene, and is used to load/unload
##          the mini-games as well as transition from the game to game over
##          scene.
##
## Author(s): Adam Goodyear, Tessa Power

# King States
# TODO: turn this into a dictionary
const king_asleep = preload("res://assets/graphics/king/king_asleep.png")
const king_bored = preload("res://assets/graphics/king/king_bored.png")
const king_laughing = preload("res://assets/graphics/king/king_laugh.png")
const king_neutral = preload("res://assets/graphics/king/king_neutral.png")
const king_pleased = preload("res://assets/graphics/king/king_pleased.png")

# Mini-games
var mini_games : Array = []
const APPLE_SHOOTING = preload("res://scenes/mini_games/apple_shooting/apple_shooting.tscn")
const JUGGLING = preload("res://scenes/mini_games/juggling.tscn")
const KNIFE_THROWING = preload("res://scenes/mini_games/knife_throwing/knife_throwing.tscn")
const TYPING = preload("res://scenes/mini_games/typing.tscn")
const SWORD_SWALLOWING = preload("res://scenes/mini_games/sword_swallowing.tscn")

# Mini-games to play this round
var current_round : Array = []

var mini_game_instance : Node = null
var played_games : Array = []
var current_idx = 0

# Background Music & SFX
@export_category("Background Music")
@export_file var background_music_file
var background_music : AudioStream
const BG_MUSIC_VOLUME : float = -5.0

func _ready():
	# TODO: add mini-games here!
	mini_games.append(JUGGLING)
	mini_games.append(KNIFE_THROWING)
	mini_games.append(TYPING)
	mini_games.append(APPLE_SHOOTING)
	mini_games.append(SWORD_SWALLOWING)
	mini_games.shuffle()
	generate_round()
	load_mini_game(current_idx)

	# Setup and start the background music
	if background_music_file:
		background_music = load(background_music_file)
		SoundManager.play_music_at_volume(background_music, BG_MUSIC_VOLUME)


func _process(_delta):
	# TODO: Tidy this up with an enum or function
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
	current_round.clear()
	mini_games.shuffle()
	for i in range(0,3):
		current_round.append(mini_games[i])


# Loads the mini-game at the given index and hooks it up to the appropriate
# callback functions
func load_mini_game(idx : int) -> void:
	var mini_game = current_round[idx]
	mini_game_instance = mini_game.instantiate()
	mini_game_instance.connect("finished", self.on_finished)
	add_child(mini_game_instance)


# Unloads the current mini-game and disconnects the callback functions
func unload_mini_game() -> void:
	# We assume that the most recently added child is our mini-game
	mini_game_instance.disconnect("finished", self.on_finished)
	mini_game_instance.queue_free()


# TODO: check if this is used, remove if not
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
	$Curtains._begin_animation()



func _on_curtains_down() -> void:
	# Remove current mini-game from the scene
	unload_mini_game()
	# Move on to the next mini-game, if there is one, otherwise start a new
	# round from the beginning with increased speed!
	current_idx += 1
	if current_idx == current_round.size():
		generate_round()
		GamestateManager.next_round()
		current_idx = 0

	# Load the mini-game at the new index
	load_mini_game(current_idx)
