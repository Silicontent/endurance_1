extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "enemy"
var enemy_type = "fast"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_fast.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 390
var original_speed = 390
var velocity = Vector2.ZERO
var score_amt = 2

# REFERENCE TO PLAYER ----------------------------------------------------
onready var player = get_node("/root/Game/Player")


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	$Sprite.texture = main


func _physics_process(_delta):
	if Globals.paused == false:
		if player.alive == true:
			velocity = (player.position - position).normalized() * speed
			var _error_grab = move_and_slide(velocity)
	
	# speeds up the fast enemy slightly whenever the player uses a speed boost
	if Input.is_action_pressed("speed_boost") and player.cooldown_ref.time_left == 0:
		speed *= 1.025
		speed = clamp(speed, 390, 400)


# ESSENTIAL FUNCTIONS FOR ENEMIES ----------------------------------------
func change_speed():
	original_speed = speed
	speed *= Globals.time_multi


func change_speed_dealer():
	speed *= Globals.DEALER_MAX


func back_speed():
	speed = original_speed


func change_color():
	$Sprite.texture = same


func back_color():
	$Sprite.texture = main
