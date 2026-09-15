extends CharacterBody2D

const SPEED = 1000
var direction_state: String
var direction: Vector2
#var collision_platform_enabled: bool = false

func _ready() -> void:
	direction = get_direction()
	disable_collision_platform()

func get_direction():
	if direction_state == "left":
		return Vector2.LEFT
	elif direction_state == "right":
		return Vector2.RIGHT

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED * delta
	move_and_collide(velocity)
	
func disable_collision_platform():
	$CollisionPlatform.disabled = true

func enable_collision_platform():
	$CollisionPlatform.disabled = false
	
