extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "enemy"
var enemy_type = "imposter"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_imposter.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 250
var original_speed = 250
var velocity = Vector2.ZERO
var score_amt = 4

# REFERENCE TO PLAYER ----------------------------------------------------
onready var player = get_node("/root/Game/Player")


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	$Sprite.texture = main


func _physics_process(_delta):
	# gets the size of the screen
	var screen_size = get_viewport_rect().size
	
	if Globals.paused == false:
		if player.alive == true:
			# if-else block for detecting and mimicking input
			if Input.is_action_pressed("up"):
				velocity = Vector2(0, -speed)
			elif Input.is_action_pressed("down"):
				velocity = Vector2(0, speed)
			elif Input.is_action_pressed("left"):
				velocity = Vector2(-speed, 0)
			elif Input.is_action_pressed("right"):
				velocity = Vector2(speed, 0)
			else:
				# if there is no input, just go towards the player
				velocity = (player.position - position).normalized() * speed
			
			var _error_grab = move_and_slide(velocity)
			# clamps the enemy inside the screen, like the player
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)


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
