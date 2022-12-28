extends CanvasLayer

# used for when the pause button is pressed
signal pause_game

# preloads the textures for the invincible icon (top-right of screen)
var inv_enabled = preload("res://assets/hud/invincible_on_icon.png")
var inv_disabled = preload("res://assets/hud/invincible_off_icon.png")

onready var player = get_node("/root/Game/Player")
onready var pause_btn = $PauseButton


# HUD FUNCTION -----------------------------------------------------------
# function that updates the HUD, runs every frame from Game.gd
func update_hud(score, killed, cooldown):
	# updates the score to the current score variable
	$Score_lbl.text = str(score)
	# updates the enemies killed number to the current killed variable
	$Killed_lbl.text = str(killed)
	# updates the cooldown timer to the current time left on CooldownTimer
	$Cooldown_lbl.text = str(cooldown)
	
	# checks if the player is invincible or not
	if Globals.is_invincible == true:
		# changes the invincible icon to be a heart
		$Invincible_icon.texture = inv_enabled
	elif Globals.is_invincible == false:
		# changes the invincible icon to be a "no" sign
		$Invincible_icon.texture = inv_disabled


# PAUSE BUTTON FUNCTIONS -------------------------------------------------
# function that runs when the pause button is pressed
func _on_pausePressed():
	# sends a signal to Game.gd
	emit_signal("pause_game")


# function that detects a press of the escape button
func _input(event):
	if player.alive == true and Globals.paused == false:
		if event.is_action_pressed("escape"):
			emit_signal("pause_game")


# function that hides the pause button
func hide_pause_button():
	pause_btn.hide()
