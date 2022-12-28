extends Node2D

# SIGNALS FOR SPAWNING AND KILLING A BOSS --------------------------------
signal boss_time
signal kill_boss

# GETS REFERENCE TO EACH BOSS --------------------------------------------
export (PackedScene) var ChonkBoss

# EXTRA VARIABLES --------------------------------------------------------
var is_alive = false
var boss = -1


# BOSS SPAWNING FUNCTIONS ------------------------------------------------
# adds boss chosen in spawn_boss() to the game scene
func add_to_scene(boss_instance):
	add_child(boss_instance)
	add_to_group("bosses")
	boss_instance.position = boss_instance.spawn_pos
	emit_signal("boss_time")


# chooses a random boss to spawn
func spawn_boss():
	# makes the "boss" var empty
	boss = -1
	
	# if there is currently no boss alive, make an instance of a boss
	if is_alive == false:
		boss = ChonkBoss.instance()
		boss.is_alive = true
		is_alive = true
		add_to_scene(boss)
	
	# don't know if this is still used, try removing the return call and test
	return is_alive


# ESSENTIAL FUNCTIONS ----------------------------------------------------
# runs function in boss's script when it is damaged
func _on_bossDamaged(boss_to_damage):
	boss_to_damage.take_damage()
	if boss_to_damage.health.value <= 0:
		is_alive = false
		boss_to_damage.is_alive = false
		boss_to_damage.death()
		emit_signal("kill_boss")
