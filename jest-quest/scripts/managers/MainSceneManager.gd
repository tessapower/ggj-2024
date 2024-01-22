extends Node2D

var score = 0
var minigamesArray : Array = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	minigamesArray.append(preload("res://scenes/mini-games/JugglingMinigame.tscn"))
	instantiate_random_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func instantiate_random_scene():
	if minigamesArray.size() > 0:
		var random_index : int = rng.randi_range(0, minigamesArray.size() - 1)
		var instance: Node = minigamesArray[random_index].instantiate()
		instance.connect("failure", self.onFailure)
		instance.connect("finish", self.onFinished)
		add_child(instance)
		
func onFailure():
	score -= 1
	print("MAIN SCORE FAILURE: " + str(score))

func onFinished():
	score += 1
	print("MAIN SCORE SUCCESS: " + str(score))
	var current_scene : Node = get_child(0)
	current_scene.disconnect("failure", self.onFailure)
	current_scene.disconnect("finish", self.onFinished)
	current_scene.queue_free()
	instantiate_random_scene()

