extends Enemy

const ARRIVAL_THRESHOLD = 4.0
@onready var hitbox = $Hitbox
@onready var animated_sprite = $AnimatedSprite2D
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
	flip_character()
	move_and_slide()

func _physics_process(delta: float) -> void:
	if path_follow == null:
		return

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $StateMachine.current_state.name != "Dead":
		$StateMachine.transition_to("Dead")
	
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area != hitbox and $StateMachine.current_state.name != "Dead":
		$StateMachine.transition_to("Dead")
