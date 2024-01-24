extends Window

# submenu.gd: This script handles showing and hiding a submenu window intended
#             to be used on the start menu.
#
# Author(s): Tessa Power

@export_multiline var text_content : String = "Hello, this is a test"

func _ready() -> void:
	$Content/TextContent.set_text(text_content)


func _on_show() -> void:
	show()

# This function enables the close button to hide the popup window.
func _on_hide() -> void:
	emit_signal("close_requested")
	hide()


func _on_window_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_hide()
