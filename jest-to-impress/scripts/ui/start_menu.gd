extends CanvasLayer

# start_menu.gd: This script handles responding to button being clicked and
#                submenus opening/closing on the start menu.
#
# Author(s): Tessa Power

@onready var buttons: Array = $Content/Buttons.get_children()

# Music
@export_file var background_music_file = null
var background_music : AudioStream = null
const BG_MUSIC_VOLUME : float = -5.0

# Sound Effects
@export_file var click_sound_file = null
var click_sound : AudioStream = null

func _ready():
	if background_music_file:
		background_music = load(background_music_file)
		SoundManager.play_music_at_volume(background_music, BG_MUSIC_VOLUME)
	if click_sound_file:
		click_sound = load(click_sound_file)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	SoundManager.stop_music()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_submenu_opened() -> void:
	for button in buttons:
		button.disabled = true


func _on_button_pressed() -> void:
	if click_sound:
		SoundManager.play_ui_sound(click_sound)


func _on_submenu_closed() -> void:
	for button in buttons:
		button.disabled = false


func _on_check_box_toggled(toggled_on):
	GamestateManager.show_tutorials = toggled_on
