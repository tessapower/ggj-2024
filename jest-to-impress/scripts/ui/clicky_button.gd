extends Button

@export_file var CLICK_SOUND
var click_sound: AudioStream = null

func _ready() -> void:
    if CLICK_SOUND:
        click_sound = load(CLICK_SOUND)

func _on_pressed() -> void:
    if click_sound:
        print("click!")
        # TODO: Add the Godot Sound Manager to handle playing audio & sfx
        #SoundManager.play_ui_sound(click_sound)
