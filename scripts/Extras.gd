extends Node2D


# function that runs when the "Back" button is pressed
func _on_backPressed():
	# changes the scene to the title screen ("res://" is the root project folder)
	
	# _error_grab stops Godot from saying "func returns value, but value isn't used"
	# the _ at the beginning tells Godot that the var is never used
	var _error_grab = get_tree().change_scene("res://scenes/Title.tscn")


func _on_guidePressed():
	var _error_grab = get_tree().change_scene("res://scenes/Guide.tscn")
