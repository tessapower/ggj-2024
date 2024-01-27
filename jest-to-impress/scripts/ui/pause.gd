extends Window

# pause.gd: This script handles showing and hiding a pause menu intended to be
#           used in the game scene.
#
# Author(s): Tessa Power

# SFX
@export_category("Sound Effects")
@export_file var pause_file
var pause : AudioStream = null
@export_file var resume_file
var resume : AudioStream = null
@export_file var click_sound_file = null
var click_sound : AudioStream = null

func _ready() -> void:
	# Set up SFX
	if pause_file:
		pause = load(pause_file)
	if resume_file:
		resume = load(resume_file)
	if click_sound_file:
		click_sound = load(click_sound_file)

func _on_about_to_popup():
	if pause:
		SoundManager.play_ui_sound(pause)


func _on_hide() -> void:
	emit_signal("close_requested")
	hide()


# Buttons
func _on_resume_pressed():
	if resume:
		SoundManager.play_ui_sound(resume)
	_on_hide()
	GamestateManager.resume()


func _on_start_menu_pressed():
	GamestateManager.resume()
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_button_pressed() -> void:
	if click_sound:
		SoundManager.play_ui_sound(click_sound)
