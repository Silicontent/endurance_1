extends KinematicBody2D

signal game_over
signal enemy_killed
signal score_up
signal boss_damaged
signal powerup_collected
signal dealer_killed

var entity_type = "player"

var main = preload("res://assets/player/player.png")
var same = preload("res://assets/extra_effects/same_color_sprite.png")

onready var cooldown_ref = $Cooldown
onready var player_coll = $Area2D/CollisionShape2D
onready var player_kine_coll = $Collision_Kinematic

var velocity = Vector2.ZERO

export (int) var speed = 400
var original_speed = 400

var past_cooldown_time = 0.0
var reset_active = false
var is_inverted = false

var speed_max = 900
var speed_current = 0
var speed_falloff = 10
var total_speed = 0

var cooldown: bool = false
var cooldown_time = 9
var invincible: bool = false
var alive = true


func _ready():
	cooldown_ref.wait_time = cooldown_time
	cooldown_ref.start()
	alive = true
	player_coll.set_deferred("disabled", false)
	player_kine_coll.set_deferred("disabled", true)
	
	reset_active = false
	is_inverted = false
	
	$Sprite.texture = main
	
	add_to_group("everything")


func _physics_process(_delta):
	velocity = Vector2.ZERO
	var screen_size = get_viewport_rect().size
	
	if Globals.paused == true:
		cooldown_ref.set_deferred("paused", true)
	elif Globals.paused == false:
		cooldown_ref.set_deferred("paused", false)
	
	if Globals.paused == false:
		if alive == true:
			# thanks to u/golddotasksquestions on r/godot for helping with the speed boost
			if Input.is_action_just_pressed("speed_boost") and cooldown == true:
				$Speed_sound.play()
				speed_current = speed_max
				cooldown = false
				
				if reset_active == true:
					cooldown_ref.wait_time = past_cooldown_time
					reset_active = false
				
				past_cooldown_time = cooldown_ref.wait_time
				cooldown_ref.wait_time *= 1.2
				cooldown_ref.start()
			
			total_speed = speed + speed_current
			speed_current -= speed_falloff
			speed_current = clamp(speed_current, 0.0, speed_max)
			
			if Input.is_action_pressed("up"):
				velocity.y = -total_speed
			if Input.is_action_pressed("down"):
				velocity.y = total_speed
			if Input.is_action_pressed("left"):
				velocity.x = -total_speed
			if Input.is_action_pressed("right"):
				velocity.x = total_speed
			
			if speed_current != 0:
				invincible = true
				Globals.is_invincible = true
			else:
				invincible = false
				Globals.is_invincible = false
			
			var _error_grab = move_and_slide(velocity)
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)


func _on_cooldownTimeout():
	cooldown = true
	cooldown_ref.stop()


func kill_self():
	hide()
	alive = false
	cooldown_ref.stop()
	player_coll.set_deferred("disabled", true)
	emit_signal("game_over")


func handle_collision(body):
	if body.entity_type == "enemy":
		if invincible == true:
			if body.enemy_type == "dealer":
				Globals.dealer_alive = false
				emit_signal("dealer_killed")
			
			$Kill_sound.play()
			emit_signal("enemy_killed", body)
			emit_signal("score_up", body.score_amt)
		else:
			if body.enemy_type == "dealer":
				pass
			else:
				kill_self()

	elif body.entity_type == "boss":
		if invincible == true or speed_current != 0:
			$Kill_sound.play()
			emit_signal("boss_damaged", body)
			cooldown_ref.wait_time = cooldown_time
		else:
			kill_self()


func handle_area_collision(area):
	if area.entity_type == "powerup":
		emit_signal("powerup_collected", area)


func _on_playerEntered(body):
	handle_collision(body)


func _on_playerAreaEntered(area):
	handle_area_collision(area)


func _on_bossDead():
	cooldown_ref.wait_time = cooldown_time


func change_speed():
	original_speed = total_speed
	total_speed *= Globals.time_multi


func back_speed():
	total_speed = original_speed


func change_color():
	$Sprite.texture = same


func back_color():
	$Sprite.texture = main


func _on_cooldownResetActivated():
	past_cooldown_time = cooldown_ref.wait_time
	
	cooldown_ref.wait_time = 0.01
	cooldown = true
	cooldown_ref.stop()
	
	reset_active = true


func _on_invertControlsActivated():
	total_speed = -total_speed
	speed = -speed
	
	yield(get_tree().create_timer(4), "timeout")
	
	total_speed = -total_speed
	speed = -speed
