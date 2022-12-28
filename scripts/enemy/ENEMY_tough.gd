extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "enemy"
var enemy_type = "tough"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_tough/enemy_tough.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 210
var original_speed = 210
var velocity = Vector2.ZERO
var score_amt = 3

# REFERENCE TO PLAYER ----------------------------------------------------
onready var player = get_node("/root/Game/Player")
onready var health_bar = $Health


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	$Sprite.texture = main
	health_bar.hide()
	
	# gives the enemy a random amount of health between 3 and 6
	var max_health = randi() % 6 + 3
	health_bar.value = max_health
	health_bar.max_value = max_health


func _physics_process(_delta):
	# if the player is alive, move towards player
	if Globals.paused == false:
		if player.alive == true:
			velocity = (player.position - position).normalized() * speed
			var _error_grab = move_and_slide(velocity)


# DECREASE HEALTH (only for ToughEnemy) ----------------------------------
func minus_hp():
	health_bar.value -= 1
	health_bar.show()


# ESSENTIAL FUNCTIONS FOR ENEMIES ----------------------------------------
func change_speed():
	speed *= Globals.time_multi


func change_speed_dealer():
	speed *= Globals.DEALER_MAX


func back_speed():
	speed = original_speed


func change_color():
	$Sprite.texture = same


func back_color():
	$Sprite.texture = main
