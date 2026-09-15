extends CharacterBody2D

signal needle_shot_forward(needle_spawn_pos, direction_state)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const EPSILON = 0.01

@export var shot_cooldown: float = 0.75
var flipped: bool = false
var is_shot_on_cooldown: bool = false
var is_too_close_to_wall_to_shoot: bool = false

func _ready() -> void:
	$ShootTimer.wait_time = shot_cooldown

func move(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		flip(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func flip(direction):
	if direction < - EPSILON:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction >  EPSILON:
		rotation = 0
		scale.y = 1
		flipped = false

func can_shoot() -> bool:
	return not is_shot_on_cooldown and not is_too_close_to_wall_to_shoot 

func shoot():
	if Input.is_action_just_pressed("shoot_forward") and can_shoot():
		var direction_state
		if flipped:
			direction_state = "left"
		else:
			direction_state = "right"
		needle_shot_forward.emit($Marker2D.global_position, direction_state)
		
		is_shot_on_cooldown = true
		$ShootTimer.start()

func _physics_process(delta: float) -> void:
	move(delta)
	shoot()


func _on_shoot_timer_timeout() -> void:
	is_shot_on_cooldown = false


func _on_prevent_shoot_next_to_wall_body_entered(body: Node2D) -> void:
	if Utils.is_body_a_tile_set_static(body):
		is_too_close_to_wall_to_shoot = true


func _on_prevent_shoot_next_to_wall_body_exited(body: Node2D) -> void:
	if Utils.is_body_a_tile_set_static(body):
		is_too_close_to_wall_to_shoot = false
