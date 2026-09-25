extends CharacterBody2D

signal can_walk_forward_status_change(can_walk_forward_status: bool)
signal can_jump_status_change(can_jump_status: bool)
signal can_shoot_status_change(can_shoot_status: bool)
signal can_attack_status_change(can_attack_status: bool)

const JUMP_VELOCITY = -440.0
const EPSILON = 0.01


@export var shot_cooldown: float = 0.75
@export var needle_pouch: Node
@onready var needle_array = NeedleManager.needle_array
@onready var pickable_needle_array = NeedleManager.pickable_needle_array
@onready var animated_sprite = $AnimatedSprite
var flipped: bool = false
var is_shot_on_cooldown: bool = false
var is_attack_on_cooldown: bool = false
# var is_too_close_to_wall_to_shoot: bool = false
var is_jump_unblocked: bool = true
var is_walk_forward_unblocked: bool = true
var speed = 300.0
var current_max_ammo: int = 2
var ammo: int = 2
var direction


func _ready() -> void:
	$ShootTimer.wait_time = shot_cooldown
	$Hitbox/CollisionShape2D.disabled = true

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func phase_out_horizontal_movement() -> void:
	velocity.x = move_toward(velocity.x, 0, speed)


func move_process(delta: float) -> void:
	apply_gravity(delta)
	flip_character()
	
	if can_walk_forward(): # can only walk if not too close to the wall
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)  # or 0.0 instantly
	
	move_and_slide()


func flip_character():
	if direction < - EPSILON:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction >  EPSILON:
		rotation = 0
		scale.y = 1
		flipped = false

func can_shoot() -> bool:
	return not is_attack_on_cooldown and not is_shot_on_cooldown and ammo > 0

func spawn_needle(direction_state: int):
	var needle = NeedleManager.create_needle(direction_state)
	var needle_spawn_position 
	
	needle_pouch.add_child(needle)
	needle_spawn_position = $AdjustedShotMarker.global_position
	needle.global_position = needle_spawn_position
	

func shoot_process():
	if (Input.is_action_just_pressed("shoot_forward") or Input.is_action_just_pressed("shoot_up")) and can_shoot():
		process_shot()
		if Input.is_action_just_pressed("shoot_forward"):
			if flipped:
				spawn_needle(Needle.LEFT)
			else:
				spawn_needle(Needle.RIGHT)
		elif Input.is_action_just_pressed("shoot_up"):
			spawn_needle(Needle.UP)

func process_shot():
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
	
func can_walk_forward_emitter():
	var out = is_walk_forward_unblocked
	can_walk_forward_status_change.emit(out)
	
func can_jump_emitter():
	var out = is_on_floor() and is_jump_unblocked
	can_jump_status_change.emit(out)

func can_shoot_emitter():
	var out = not is_shot_on_cooldown
	can_shoot_status_change.emit(out)

func can_pickup() -> bool:
	if pickable_needle_array.size() > 0:
		return true
	else:
		return false
		
func can_attack() -> bool:
	return not is_attack_on_cooldown and not is_shot_on_cooldown

func can_attack_emitter():
	var out = can_attack()
	can_shoot_status_change.emit(out)

func attack_process():
	if Input.is_action_just_pressed("attack") and can_attack():
		is_attack_on_cooldown = true	
		$Hitbox/CollisionShape2D.disabled = false
		$AttackTimer.start()
		$AttackFramesTimer.start()
				
func _physics_process(delta: float) -> void:
	can_walk_forward_emitter()
	can_jump_emitter()
	can_shoot_emitter()
	can_attack_emitter()

func get_closest_pickable_needle():
	return NeedleManager.find_min_dist_pickable_needle()

func pickup_process():
	if Input.is_action_just_pressed("pickup") and can_pickup():
		var picked_needle = get_closest_pickable_needle()
		NeedleManager.remove_needle(picked_needle)
		ammo += 1

func _on_shoot_timer_timeout() -> void:
	is_shot_on_cooldown = false

func _on_prevent_jump_body_entered(_body: Node2D) -> void:
	is_jump_unblocked = false

func _on_prevent_jump_body_exited(_body: Node2D) -> void:
	is_jump_unblocked = true

func _on_prevent_walk_forward_body_entered(_body: Node2D) -> void:
	is_walk_forward_unblocked = false

func _on_prevent_walk_forward_body_exited(_body: Node2D) -> void:
	is_walk_forward_unblocked = true

func _on_attack_timer_timeout() -> void:
	is_attack_on_cooldown = false
	
func _on_attack_frames_timer_timeout() -> void:
	$Hitbox/CollisionShape2D.disabled = true
