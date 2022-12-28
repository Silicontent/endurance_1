extends CanvasLayer

signal unpause


# function used when the TitleButton is pressed
func to_title():
	var _error_grab = get_tree().change_scene("res://scenes/Title.tscn")


# KEY INPUT FUNCTION -----------------------------------------------------
func _input(event):
	if Globals.paused == true:
		if event.is_action_pressed("enter"):
			emit_signal("unpause")


# BUTTON PRESSED FUNCTIONS -----------------------------------------------
func _on_unpausePressed():
	emit_signal("unpause")


func _on_titlePressed():
	to_title()
