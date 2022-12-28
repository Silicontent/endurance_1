extends CanvasLayer

onready var anim_player = $AnimationPlayer
onready var notif_label = $NotifLabel


func _ready():
	notif_label.hide()


func _on_cooldownReset():
	notif_label.text = "Your speed boost cooldown has been reset!"
	anim_player.play("hud_fade")


func _on_invertControls():
	notif_label.text = "Your controls have been inverted!"
	anim_player.play("hud_fade")


func _on_sameColor():
	notif_label.text = "Everything is the same color!"
	anim_player.play("hud_fade")


func _on_screenWipe():
	notif_label.text = "The screen has been wiped!"
	anim_player.play("hud_fade")


func _on_spawnBoss():
	notif_label.text = "A boss has spawned!"
	anim_player.play("hud_fade")


func _on_timeSlow():
	notif_label.text = "Time has been slowed down!"
	anim_player.play("hud_fade")
