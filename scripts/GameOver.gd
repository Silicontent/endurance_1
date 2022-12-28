extends CanvasLayer

# variable to contain an instance of Player
var player = null


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	# hides the pop-up saying "New High-Score!"
	$HighScoreLabel.hide()


func _process(_delta):
	# runs if the player is dead
	if player.alive == false:
		# checks for keyboard input
		if Input.is_action_pressed("enter"):
			var _error_grab = get_tree().change_scene("res://scenes/Game.tscn")
		if Input.is_action_pressed("escape"):
			var _error_grab = get_tree().change_scene("res://scenes/Title.tscn")


# HUD UPDATING FUNCTIONS -------------------------------------------------
func update_score(score, enemies_killed, high_score):
	# variable for holding HUD information
	var text = "Score: %d | Enemies Killed: %d" % [score, enemies_killed]
	# sets the text of the Label node to the correct information
	$Stats.text = text
	
	# if the high score is less than the score earned in that run, show
	# the high score pop-up
	if high_score < score:
		$HighScoreLabel.show()


# function that gets an instance of Player and saves it in a variable
func get_player_info(player_inst):
	player = player_inst


# PRESSED BUTTON FUNCTIONS -----------------------------------------------
# runs when the RestartButton is pressed
func _on_restartPressed():
	var _error_grab = get_tree().change_scene("res://scenes/Game.tscn")


# runs when the TitleButton is pressed
func _on_titlePressed():
	var _error_grab = get_tree().change_scene("res://scenes/Title.tscn")
