extends CanvasLayer

# start_menu.gd: This script handles responding to button being clicked and
#                submenus opening/closing on the start menu.
#
# Author(s): Tessa Power

# TODO: Ensure the submenus actually contain legitimate content

@onready var buttons : Array = $Content/Buttons.get_children()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_submenu_opened() -> void:
	for button in buttons:
		button.disabled = true


func _on_submenu_closed() -> void:
	for button in buttons:
		button.disabled = false
