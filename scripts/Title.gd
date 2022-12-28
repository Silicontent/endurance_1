extends Node2D


func _ready():
	randomize()
	$HUD/HighScore.text = "High Score: %d" % Globals.high_score


func _on_startPressed():
	var _error_grab = get_tree().change_scene("res://scenes/Game.tscn")


func _on_extrasPressed():
	var _error_grab = get_tree().change_scene("res://scenes/Extras.tscn")


func _process(_delta):
	if Input.is_action_pressed("enter"):
		var _error_grab = get_tree().change_scene("res://scenes/Game.tscn")
