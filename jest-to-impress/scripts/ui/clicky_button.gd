extends Button

@onready var click_sound: AudioStream = load("res://assets/audio/sfx/Button_press.mp3")

func _on_pressed() -> void:
	if click_sound:
		SoundManager.play_ui_sound(click_sound)
