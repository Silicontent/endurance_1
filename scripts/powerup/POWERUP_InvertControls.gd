extends Area2D

var entity_type = "powerup"
var powerup_type = "invert_controls"


func decay_timer():
	$DecayTimer.start()


func _on_decayTimeout():
	queue_free()
