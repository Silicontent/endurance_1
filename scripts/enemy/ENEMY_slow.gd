# nickname: "Bob"
extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "enemy"
var enemy_type = "slow"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_slow.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 50
var original_speed = 50
var velocity = Vector2.ZERO
var score_amt = 3

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
