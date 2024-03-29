extends MiniGame

## apple_particles.gd: A script to manage the apple explosion particles.
##
## Author(s): Adam Goodyear

const APPLE = preload("res://scenes/mini_games/apple_shooting/apple.tscn")

var apples : Array = []
var rng = RandomNumberGenerator.new()
static var has_played : bool = false

func _ready():
	$Tutorial.connect("close_requested", self.hide_tutorial)
	if GamestateManager.show_tutorials and not has_played:
		show_tutorial()
		has_played = true
	else:
		hide_tutorial()

	for i in range(0, 3):
		var apple_instance = APPLE.instantiate()
		# TODO: Add ReferenceRect as spawning area
		var random_pos_x = rng.randi_range(-get_viewport_rect().size[0] / 2 + 200, get_viewport_rect().size[0] / 2 - 200)
		var random_pos_y = rng.randi_range(-get_viewport_rect().size[1] / 2 + 200, get_viewport_rect().size[1] / 2 - 200)
		apple_instance.global_position = Vector2(random_pos_x,random_pos_y)
		apples.append(apple_instance)
		add_child(apple_instance)

	$Progress.max_value = $Timer.wait_time
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Progress.value = $Timer.time_left

	if Input.is_action_just_pressed("LeftClick"):
		var hit = false
		for i in range(apples.size() -1, -1, -1):
			if apples[i] != null and apples[i].mouse_detected:
				hit = true
				apples[i].destroy_apple()
				apples.remove_at(i)
		if !hit:
			GamestateManager.update_attention_meter(MiniGame.Rating.FAILED)

	if apples.size() < 1:
		on_finished()


func _on_timer_timeout():
	GamestateManager.update_attention_meter(MiniGame.Rating.FAILED)
	on_finished()
