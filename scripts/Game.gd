extends Node2D

# REFERENCES TO NODES IN THE GAME ----------------------------------------
# timers
onready var enemy_timer = $Timers/EnemyTimer
onready var score_timer = $Timers/ScoreTimer
onready var powerup_timer = $Timers/PowerupTimer
onready var same_color_timer = $Timers/SameColorTimer

# managers
onready var enemy_mang = $EnemyManager
onready var boss_mang = $BossManager
onready var powerup_mang = $PowerupManager

# GUI elements
onready var game_over = $GameOver
onready var pause_menu = $PauseMenu
onready var hud = $HUD

# player
onready var player = $Player
onready var player_cooldown = $Player/Cooldown

# SCORING VARIABLES (and others) -----------------------------------------
var score = 0
var high_score = Globals.high_score
var killed = 0

var above_boss_level = false


# SET-UP CODE ------------------------------------------------------------
func initialize():
	# starts all timers
	enemy_timer.start()
	powerup_timer.wait_time = randi() % 20 + 10
	powerup_timer.start()
	# sends the instance of Player to the GameOver GUI
	game_over.get_player_info(player)
	
	# resets global variables
	Globals.is_slow_active = false
	Globals.is_same_color_active = false
	Globals.is_invincible = false
	Globals.above_boss_level = false
	Globals.dealer_alive = false
	Globals.paused = false
	
	# extra stuff
	$PowerupManager/CanvasLayer/Vignette.hide()


func _ready():
	initialize()


func _process(_delta):
	# updates the HUD
	hud.update_hud(score, killed, stepify(player_cooldown.time_left, 0.1))
	
	# if score is above 300, the SpawnBoss powerup can now appear
	if score >= 300 and Globals.above_boss_level == false:
		Globals.above_boss_level = true
	
	# DEBUG ONLY
	#if Input.is_action_just_released("debug_score_up"):
	#	score += 100


# PAUSE CODE -------------------------------------------------------------
# called as a signal from HUD and PauseMenu
func pause_game():
	if Globals.paused == false:
		# pauses all timers
		enemy_timer.set_deferred("paused", true)
		score_timer.set_deferred("paused", true)
		powerup_timer.set_deferred("paused", true)
		
		# moves around GUI
		pause_menu.offset = Vector2(0, 0)
		hud.offset = Vector2(-1300, 0)
		game_over.offset = Vector2(-1300, 0)
		
		# changes global variable
		Globals.paused = true
	
	elif Globals.paused == true:
		# unpauses all timers
		enemy_timer.set_deferred("paused", false)
		score_timer.set_deferred("paused", false)
		powerup_timer.set_deferred("paused", false)
		
		# moves around GUI
		pause_menu.offset = Vector2(-1300, 0)
		hud.offset = Vector2(0, 0)
		game_over.offset = Vector2(-1300, 0)
		
		# changes global variable
		Globals.paused = false


# SCORE CODE -------------------------------------------------------------
# survival score function - adds 1 score and restarts ScoreTimer
func _on_addScore():
	score += 1
	score_timer.start()


# enemy score function - adds 1 to killed var and adds correct score amt
func _on_scoreUp(score_amt):
	killed += 1
	score += score_amt


# GAME OVER CODE ---------------------------------------------------------
func _on_gameOver():
	# plays the death sound
	$Death_sound.play()
	
	# stops all timers
	enemy_timer.stop()
	score_timer.stop()
	powerup_timer.stop()
	
	# tells the HUD to hide the pause button
	hud.hide_pause_button()
	
	# starts a one-shot timer to add a delay
	yield(get_tree().create_timer(1.5), "timeout")
	
	# moves around GUI
	game_over.offset = Vector2(0, 0)
	hud.offset = Vector2(-1300, 0)
	pause_menu.offset = Vector2(-1300, 0)
	
	# changes the high score if your score was higher than it
	if high_score < score:
		Globals.high_score = score
	
	# updates the GameOver GUI to display accurate information
	game_over.update_score(score, killed, high_score)


# ENEMY CODE -------------------------------------------------------------
func _on_enemyTimeout():
	# spawns new enemy when EnemyTimer runs out
	# EnemyTimer restarts itself
	enemy_mang.choose_enemy()


func _on_dealerSpawned():
	# runs the function change_speed_dealer() in all enemy scripts
	get_tree().call_group("everything", "change_speed_dealer")


func _on_dealerKilled():
	# resets all enemys' speeds when the dealer enemy dies
	get_tree().call_group("everything", "back_speed")
	# if the TimeSlow power-up is active, make sure all enemies
	# are affected by it
	if Globals.is_slow_active == true:
		get_tree().call_group("everything", "change_speed")


# BOSS CODE --------------------------------------------------------------
func _on_bossSpawned():
	# tells other managers to remove enemies & power-ups when boss spawns
	enemy_mang.boss_spawned()
	powerup_mang.boss_spawned()
	
	# stops scoring, enemy-spawn, and powerup-spawn timers
	enemy_timer.stop()
	powerup_timer.stop()
	score_timer.stop()
	
	# re-enables the Player's KinematicBody collision
	# this keeps the player from going behind the boss
	player.player_kine_coll.set_deferred("disabled", false)


# paramater "body" will be used when new bosses are added
# adds score whenever a boss takes damage
func _on_bossDamaged(_body):
	score += 2


func _on_bossDead():
	# adds score when the boss is killed
	score += 50
	killed += 1
	
	# starts timers that were disabled in _on_bossSpawned()
	enemy_timer.start()
	powerup_timer.start()
	score_timer.start()
	
	# disables the Player's KinematicBody collision
	# this makes running into a lot of normal enemies much smoother
	player.player_kine_coll.set_deferred("disabled", true)


# POWER-UP CODE ----------------------------------------------------------
func _on_powerupTimeout():
	# spawns a new power-up when PowerupTimer runs out
	powerup_mang.spawn_powerup()
	
	# chooses a random amount of wait time for PowerupTimer, making
	# power-up spawning much more varied
	powerup_timer.wait_time = randi() % 15 + 10
	# PowerupTimer doesn't restart automatically, so it's started here
	powerup_timer.start()


# runs when the player collects the TimeSlow power-up
func _on_timeSlowActivated():
	# global variable editing
	Globals.time_multi = Globals.TIME_MIN
	Globals.is_slow_active = true
	
	# runs function in all enemies to change their speed
	get_tree().call_group("everything", "change_speed")
	
	# shows the vignette around the screen
	$PowerupManager/CanvasLayer/Vignette.show()
	
	yield(get_tree().create_timer(10), "timeout")
	
	# changing global variables back to their default values
	Globals.time_multi = Globals.TIME_MAX
	Globals.is_slow_active = false
	
	# runs function in all enemies to change their speed back
	get_tree().call_group("everything", "back_speed")
	
	# hides the vignette around the screen
	$PowerupManager/CanvasLayer/Vignette.hide()


# runs when the player collects the SameColor power-up
func _on_sameColorActivated():
	# runs function in Player.gd that changes the player's color
	# the func for changing the enemies's color is in the EnemyManager script
	player.change_color()
	Globals.is_same_color_active = true
	
	# starts the timer for the SameColor power-up
	same_color_timer.start()
	# pauses the function until the SameColor timer finishes
	yield(same_color_timer, "timeout")
	
	# runs function in Player.gd that resets the player's color
	player.back_color()
	Globals.is_same_color_active = false


# runs when the player collects the SpawnBoss power-up
func _on_spawnBossActivated(powerup):
	# if a power-up manages to spawn before the player gets above 300,
	# it won't do anything when collected. Probably can be removed, but
	# isn't that big of a deal
	if score < 300:
		powerup.queue_free()
	elif score >= 300:
		# runs the function inside BossManager.gd to spawn a boss
		boss_mang.spawn_boss()
