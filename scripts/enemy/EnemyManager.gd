extends Node2D

# SIGNALS ----------------------------------------------------------------
signal dealer_spawned

# GETS REFERENCE TO EACH ENEMY -------------------------------------------
export (PackedScene) var NormalEnemy
export (PackedScene) var FastEnemy
export (PackedScene) var SlowEnemy
export (PackedScene) var ImposterEnemy
export (PackedScene) var ToughEnemy
export (PackedScene) var DealerEnemy

# ENEMY SPAWNING FUNCTIONS -----------------------------------------------
# chooses a random enemy using a randi() - needs rebalancing!
func choose_enemy():
	# random number to decide which enemy to spawn
	var spawn_chance = randi() % 100 + 1
	
	# creates a blank enemy variable
	var enemy = -1
	
	# fast - 29 possible values
	if spawn_chance <= 22:
		enemy = FastEnemy.instance()
	
	# slow - 16 possible values
	elif spawn_chance >= 23 and spawn_chance <= 38:
		enemy = SlowEnemy.instance()
	
	# imposter/impostor - 5 possible values
	elif spawn_chance >= 39 and spawn_chance <= 43:
		enemy = ImposterEnemy.instance()
	
	# tough - 14 possible values
	elif spawn_chance >= 44 and spawn_chance <= 55:
		enemy = ToughEnemy.instance()
	
	# dealer - 4 possible values
	elif spawn_chance >= 56 and spawn_chance <= 59 and Globals.dealer_alive == false:
		Globals.dealer_alive = true
		enemy = DealerEnemy.instance()
	
	# normal - 41 possible values
	elif spawn_chance >= 60:
		enemy = NormalEnemy.instance()
	
	# mostly a fail-safe, if any of the above if-elif statements fail
	else:
		enemy = NormalEnemy.instance()
	
	# special logic for if the enemy is a dealer
	if enemy.enemy_type == "dealer":
		$Dealer_Path/Dealer_Spawn.offset = randi()
		var stop_pos = $Dealer_Path/Dealer_Spawn.position
		enemy.stop_pos = stop_pos
		emit_signal("dealer_spawned")
	
	# adds enemy to scene and to groups
	add_child(enemy)
	enemy.add_to_group("everything")
	enemy.add_to_group("enemies")
	
	# chooses random point around the screen
	$Enemy_Path/Enemy_Spawn.offset = randi()
	enemy.position = $Enemy_Path/Enemy_Spawn.position
	
	# makes sure a power-up's or the dealer's effect apply to a
	# newly-spawned enemy
	if Globals.is_slow_active == true:
		enemy.change_speed()
	if Globals.is_same_color_active == true:
		enemy.change_color()
	if Globals.dealer_alive == true:
		enemy.change_speed_dealer()


# ENEMY DAMAGING FUNCTION ------------------------------------------------
func _on_enemyKilled(enemy):
	if enemy.enemy_type == "tough":
		if enemy.health_bar.value <= 1:
			enemy.score_amt = 3
			enemy.queue_free()
		else:
			enemy.score_amt = 0
			enemy.minus_hp()
	else:
		enemy.queue_free()


# ENEMY REACTIONS TO EVENTS AND POWER-UPS --------------------------------
func boss_spawned():
	get_tree().call_group("enemies", "queue_free")


func _on_screenWipe():
	get_tree().call_group("enemies", "queue_free")


func _on_sameColor():
	get_tree().call_group("enemies", "change_color")
	yield(get_node("/root/Game/Timers/SameColorTimer"), "timeout")
	get_tree().call_group("enemies", "back_color")
