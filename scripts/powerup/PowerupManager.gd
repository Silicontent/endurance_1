extends Node2D

export (PackedScene) var ScreenWipe
signal screen_wipe
export (PackedScene) var TimeSlow
signal time_slow
export (PackedScene) var SameColor
signal same_color
export (PackedScene) var CooldownReset
signal cooldown_reset
export (PackedScene) var InvertControls
signal invert_controls
export (PackedScene) var SpawnBoss
signal spawn_boss_activate


func _ready():
	$CanvasLayer/Flash.hide()


func add_to_scene(powerup):
	add_child(powerup)
	powerup.add_to_group("powerups")
	
	var spawn_location = Vector2.ZERO
	spawn_location.x = randi() % 1280
	spawn_location.y = randi() % 720
	
	powerup.position = spawn_location
	powerup.decay_timer()


func spawn_powerup():
	var random_one = randi() % 5 + 1
	var random_boss = randi() % 1000
	var powerup = -1
	
	if random_boss >= 800 and Globals.above_boss_level == true:
		powerup = SpawnBoss.instance()
		add_to_scene(powerup)
	else:
		match (random_one):
			1:  # good powerup
				powerup = ScreenWipe.instance()
				add_to_scene(powerup)
			2:  # good powerup
				powerup = TimeSlow.instance()
				add_to_scene(powerup)
			3:  # good powerup
				powerup = CooldownReset.instance()
				add_to_scene(powerup)
			4:  # bad powerup
				powerup = SameColor.instance()
				add_to_scene(powerup)
			5:  # bad powerup
				powerup = InvertControls.instance()
				add_to_scene(powerup)
			_:
				powerup = -1


func _on_powerupCollected(powerup):
	powerup.queue_free()
	
	if powerup.powerup_type == "screen_wipe":
		emit_signal("screen_wipe")
		$CanvasLayer/Flash.show()
		$CanvasLayer/Flash/AnimationPlayer.play("screen_wipe_flash")
		
	elif powerup.powerup_type == "time_slow":
		if Globals.is_slow_active == false:
			emit_signal("time_slow")
	
	elif powerup.powerup_type == "same_color":
		emit_signal("same_color")
	
	elif powerup.powerup_type == "cooldown_reset":
		emit_signal("cooldown_reset")
	
	elif powerup.powerup_type == "invert_controls":
		emit_signal("invert_controls")
	
	elif powerup.powerup_type == "spawn_boss":
		emit_signal("spawn_boss_activate", powerup)


func boss_spawned():
	get_tree().call_group("powerups", "queue_free")
