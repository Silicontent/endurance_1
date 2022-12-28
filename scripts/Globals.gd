extends Node

# GAMEPLAY VARIABLES -----------------------------------------------------
# stores the player's high score
var high_score = 0
# stores the current pause state
var paused = false

# VARIABLES FOR THE DEALER ENEMY -----------------------------------------
# the constant by which each enemy's speed is multiplied by
const DEALER_MAX = 1.025
# set as "true" if a dealer enemy is alive, used to prevent more than 1 dealer
# spawning
var dealer_alive = false

# TIME-SLOW POWER-UP VARIABLES -------------------------------------------
# used to reset all enemy speeds back to their original speeds
const TIME_MAX = 1
# multiplied with all enemy speeds to slow them down
const TIME_MIN = 0.3
# changed to either TIME_MAX or TIME_MIN if a TimeSlow power-up is active
var time_multi = 1

# CURRENTLY ACTIVE POWER-UP VARIABLES ------------------------------------
# set as "true" if the player is currently invincible
var is_invincible = false
# set as "true" if a TimeSlow power-up is active
var is_slow_active = false
# set as "true" if a SameColor power-up is active
var is_same_color_active = false

# set as "true" if the score is above 300, allowing the SpawnBoss power-up to
# appear
var above_boss_level = false

