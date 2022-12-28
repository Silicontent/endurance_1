extends Area2D

var entity_type = "powerup"
var powerup_type = "same_color"


func decay_timer():
	$DecayTimer.start()


func _on_decayTimeout():
	queue_free()
