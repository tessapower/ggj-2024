extends Node2D

var score = 0
var mini_games : Array = []
var rng = RandomNumberGenerator.new()

const juggling = preload("res://scenes/mini_games/juggling.tscn")
const knife_throwing = preload("res://scenes/mini_games/knife_throwing/knife_throwing.tscn")

func _ready():
    mini_games.append(juggling)
    instantiate_random_scene()


func instantiate_random_scene():
    if mini_games.size() > 0:
        var random_index : int = rng.randi_range(0, mini_games.size() - 1)
        var instance: Node = mini_games[random_index].instantiate()
        instance.connect("failure", self.on_failure)
        instance.connect("finish", self.on_finished)
        add_child(instance)


func on_failure():
    score -= 1
    print("MAIN SCORE FAILURE: " + str(score))


func on_finished():
    score += 1
    print("MAIN SCORE SUCCESS: " + str(score))
    var current_scene : Node = get_child(0)
    current_scene.disconnect("failure", self.on_failure)
    current_scene.disconnect("finish", self.on_finished)
    current_scene.queue_free()
    instantiate_random_scene()
