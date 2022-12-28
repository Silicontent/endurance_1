extends Area2D

var entity_type = "powerup"
var powerup_type = "screen_wipe"


func decay_timer():
	$DecayTimer.start()


func _on_decayTimeout():
	queue_free()
