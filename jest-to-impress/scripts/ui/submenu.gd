class_name Submenu extends Window

# submenu.gd: This script handles showing and hiding a submenu window intended
#             to be used on the start menu.
#
# Author(s): Tessa Power

@export_multiline var text_content : String = "Hello, this is a test."
@onready var click_sound: AudioStream = load("res://assets/audio/sfx/Button_press.mp3")

func _ready() -> void:
	$Content/ScrollContainer/TextContent.set_text(text_content)

func set_text(text : String) -> void:
	text_content = text

func _on_show() -> void:
	show()

# This function enables the close button to hide the popup window.
func _on_hide() -> void:
	emit_signal("close_requested")
	if click_sound:
		SoundManager.play_ui_sound(click_sound)
	hide()


func _on_window_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_hide()
