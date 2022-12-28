extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS -------------------------------------
var entity_type = "enemy"
# describes what type of ENEMY this enemy is
var enemy_type = "dealer"

# SPRITE LOADING FOR THE "SAME COLOR" POWER-UP ---------------------------
var main = preload("res://assets/enemies/enemy_dealer.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

# STATS ------------------------------------------------------------------
export (int) var speed = 250
var original_speed = 250
var velocity = Vector2.ZERO
var score_amt = 2

var reached_spot = false
var stop_pos = Vector2.ZERO

# REFERENCES TO STOP AREA AND PLAYER -------------------------------------
onready var stop_area = $DealerStop
onready var player = get_node("/root/Game/Player")


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	$Sprite.texture = main
	stop_area.global_position = stop_pos


func _physics_process(_delta):
	if Globals.paused == false:
		if player.alive == true:
			if reached_spot == false:
				stop_area.global_position = stop_pos
				velocity = (stop_pos - position).normalized() * speed
				var _error_grab = move_and_slide(velocity)


# STOP FUNCTIONS ---------------------------------------------------------
func stop_moving():
	reached_spot = true


func _on_stopAreaEntered(body):
	if body.entity_type == "enemy":
		if body.enemy_type == "dealer":
			stop_moving()


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
