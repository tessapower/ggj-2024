extends "res://scripts/mini_games/mini_game.gd"

var sword_offset
var sword_hovered = false

static var has_played : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tutorial.connect("close_requested", self.hide_tutorial)
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true
	else:
		hide_tutorial()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sword_hovered:
		if Input.is_action_just_pressed("LeftClick"):
			sword_offset = $Node2D/sword.global_position - get_global_mouse_position()

		if Input.is_action_pressed("LeftClick") and sword_offset != null:
			$Node2D/sword.global_position = get_global_mouse_position() + sword_offset


func _on_sword_mouse_entered():
	sword_hovered = true


func _on_sword_mouse_exited():
	sword_hovered = false


func _on_first_area_entered(_area):
	GamestateManager.update_attention_meter(Rating.FAILED)
	call_deferred("on_finished")


func _on_second_area_entered(_area):
	GamestateManager.update_attention_meter(Rating.FAILED)
	call_deferred("on_finished")


func _on_success(_area):
	GamestateManager.update_attention_meter(Rating.PERFECT)
	call_deferred("on_finished")
