extends KinematicBody2D

# ENTITY TYPE USED BY OTHER SCRIPTS --------------------------------------
var entity_type = "boss"

# STATS AND OTHER VARIABLES ----------------------------------------------
export (int) var speed = 20
var spawn_pos = Vector2(-204, 265)
var velocity = Vector2.ZERO
var is_alive = true

# REFERENCES TO HEALTH BAR AND PLAYER ------------------------------------
onready var health = $ChonkHealth/HealthBar
onready var player = get_node("/root/Game/Player")


# BUILT-IN FUNCTIONS -----------------------------------------------------
func _ready():
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite.animation = "phase1"
	health.tint_progress = Color8(0, 38, 255, 255)


func _physics_process(_delta):
	if player.alive == true and is_alive == true:
		# moves the boss while the player and the boss is alive
		velocity = (player.position - position).normalized() * speed
		var _error_grab = move_and_slide(velocity)


# ESSENTIAL FUNCTIONS FOR BOSSES -----------------------------------------
# runs when the boss takes damage
func take_damage():
	health.value -= randi() % 5 + 1
	if health.value <= 50:
		speed = 100
		# Color8() allows use of RGB, Color() uses RGB %s
		health.tint_progress = Color8(252, 252, 3, 255)
		$AnimatedSprite.animation = "phase2"
	if health.value <= 20:
		speed = 130
		health.tint_progress = Color8(255, 0, 0, 255)
		$AnimatedSprite.animation = "phase3"


# runs when the boss dies
func death():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.animation = "dead"
	$AnimationPlayer.play("death")
	$Death_sound.play()
	
	yield($AnimationPlayer, "animation_finished")
	queue_free()
