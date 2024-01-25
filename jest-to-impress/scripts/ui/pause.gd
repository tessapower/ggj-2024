extends Window

# pause.gd: This script handles showing and hiding a pause menu intended to be
#           used in the game scene.
#
# Author(s): Tessa Power


func _on_hide() -> void:
	emit_signal("close_requested")
	hide()

# Buttons
func _on_resume_pressed():
	_on_hide()
	GamestateManager.resume()


func _on_start_menu_pressed():
	GamestateManager.resume()
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()
