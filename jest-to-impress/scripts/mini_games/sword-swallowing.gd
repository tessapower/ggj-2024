extends "res://scripts/mini_games/mini_game.gd"

var swordOffset
var swordHovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tutorial.connect("close_requested", self.hide_tutorial)
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if swordHovered:
		if Input.is_action_just_pressed("LeftClick"):
			swordOffset = $Node2D/sword.global_position - get_global_mouse_position()
	
		if Input.is_action_pressed("LeftClick") and swordOffset != null:
			$Node2D/sword.global_position = get_global_mouse_position() + swordOffset
	
func _on_sword_mouse_entered():
	swordHovered = true
	
func _on_sword_mouse_exited():
	swordHovered = false
	
func _on_first_area_entered(area):
	GamestateManager.update_attention_meter(Rating.FAILED)
	call_deferred("on_finished")
	
func _on_second_area_entered(area):
	GamestateManager.update_attention_meter(Rating.FAILED)
	call_deferred("on_finished")
	
func _on_success(area):
	GamestateManager.update_attention_meter(Rating.PERFECT)
	call_deferred("on_finished")
