extends Node2D

## jester_bow.gd: Handles pointing the jester with a bow in the direction of
##                the mouse.
##
## Author(s): Adam Goodyear

func _process(_delta):
	$TopHalf.look_at(get_global_mouse_position())
