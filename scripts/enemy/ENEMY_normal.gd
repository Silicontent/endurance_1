extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "enemy"
var enemy_type = "normal"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_normal.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 200
var original_speed = 200
var velocity = Vector2.ZERO
var score_amt = 1
var size = (randi() % 4 + 1) * 0.1

# REFERENCE TO PLAYER ----------------------------------------------------
onready var player = get_node("/root/Game/Player")


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	scale = Vector2(size, size)
	$Sprite.texture = main


func _physics_process(_delta):
	# if the player is alive, move towards player
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
