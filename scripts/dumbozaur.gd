extends Enemy

const ARRIVAL_THRESHOLD = 4.0
@export var path_follow: PathFollow2D
@export var movement_speed: float
 
var path_follow_direction: int = 1  # 1 = forward along path, -1 = backward

func _ready() -> void:
	speed = movement_speed
	if path_follow == null:
		push_warning("Enemy: no path_follow assigned!")
		return
	path_follow.loop = false

func roam_move_process(delta):
	# Advance along the path
	path_follow.progress += speed * path_follow_direction * delta

	# Reverse at the ends
	if path_follow.progress_ratio >= 1.0:
		path_follow.progress_ratio = 1.0
		path_follow_direction = -1
	elif path_follow.progress_ratio <= 0.0:
		path_follow.progress_ratio = 0.0
		path_follow_direction = 1

	# Move the enemy toward the path-follow's global position
	var target_position := path_follow.global_position.x
	var to_target = target_position - global_position.x
	
	velocity = Vector2.ZERO
	if abs(to_target) > ARRIVAL_THRESHOLD:
		direction = sign(to_target)
		velocity.x = direction * speed
	else:
		velocity = Vector2.ZERO
		global_position.x = target_position  # snap exactly, avoids jitter
	
	apply_gravity(delta)
	move_and_slide()


func _physics_process(delta: float) -> void:
	if path_follow == null:
		return

	
