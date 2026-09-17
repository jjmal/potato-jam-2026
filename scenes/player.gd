extends CharacterBody2D

const NeedlePreload: PackedScene = preload("res://scenes/needle.tscn")

signal can_walk_forward_status_change(can_walk_forward_status: bool)
signal can_jump_status_change(can_jump_status: bool)

const JUMP_VELOCITY = -400.0
const EPSILON = 0.01

@export var shot_cooldown: float = 0.75
@onready var needle_array = $NeedleManager.needle_array
var flipped: bool = false
var is_shot_on_cooldown: bool = false
var is_too_close_to_wall_to_shoot: bool = false
var is_jump_unblocked: bool = true
var is_walk_forward_unblocked: bool = true
var speed = 300.0
var ammo: int = 2


func _ready() -> void:
	$ShootTimer.wait_time = shot_cooldown
		
func move(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	flip_character(direction) # can always flip
	
	
	if direction and can_walk_forward(): # can only walk if not too close to the wall
		velocity.x = direction * speed
	else: # speed 0 guard
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


func flip_character(direction):
	if direction < - EPSILON:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction >  EPSILON:
		rotation = 0
		scale.y = 1
		flipped = false

func can_shoot() -> bool:
	return not is_shot_on_cooldown and ammo > 0

func shoot():
	
	if Input.is_action_just_pressed("shoot_forward") and can_shoot():
		print('yay')
		var needle = NeedlePreload.instantiate()
		var direction_state
		var needle_spawn_position 
		
		if flipped:
			direction_state = "left"
		else:
			direction_state = "right"
			
		if not is_too_close_to_wall_to_shoot:
			needle_spawn_position  = $DefaultShotMarker.global_position
		else: 
			needle_spawn_position  = $AdjustedShotMarker.global_position
		
		needle.global_position = needle_spawn_position 
		needle.direction_state = direction_state
		$NeedleManager.add_child(needle)
		needle_array.append(needle)
		
		is_shot_on_cooldown = true
		$ShootTimer.start()
		
		ammo -= 1

func can_jump() -> bool:
	var out = is_on_floor() and is_jump_unblocked
	can_jump_status_change.emit(out)
	return out
	
func can_walk_forward() -> bool:
	var out = is_walk_forward_unblocked
	can_walk_forward_status_change.emit(out)
	return out

func _physics_process(delta: float) -> void:
	move(delta)
	shoot()

func _on_shoot_timer_timeout() -> void:
	is_shot_on_cooldown = false

func _on_prevent_shoot_next_to_wall_body_entered(_body: Node2D) -> void:
	is_too_close_to_wall_to_shoot = true

func _on_prevent_shoot_next_to_wall_body_exited(_body: Node2D) -> void:
	is_too_close_to_wall_to_shoot = false

func _on_prevent_jump_body_entered(_body: Node2D) -> void:
	is_jump_unblocked = false

func _on_prevent_jump_body_exited(_body: Node2D) -> void:
	is_jump_unblocked = true

func _on_prevent_walk_forward_body_entered(_body: Node2D) -> void:
	is_walk_forward_unblocked = false

func _on_prevent_walk_forward_body_exited(_body: Node2D) -> void:
	is_walk_forward_unblocked = true
