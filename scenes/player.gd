extends CharacterBody2D

signal needle_shot_forward(needle_spawn_pos, direction_state)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const EPSILON = 0.01

@export var shot_cooldown: float = 0.75
var flipped: bool = false
var can_shoot: bool = true

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

func shoot():
	if Input.is_action_just_pressed("shoot_forward") and can_shoot:
		var direction_state
		if flipped:
			direction_state = "left"
		else:
			direction_state = "right"
		needle_shot_forward.emit($Marker2D.global_position, direction_state)
		
		can_shoot = false
		$ShootTimer.start()

func _physics_process(delta: float) -> void:
	move(delta)
	shoot()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
