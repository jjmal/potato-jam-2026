extends CharacterBody2D
class_name Enemy
const JUMP_VELOCITY = -400.0

var speed: float
var can_player_walk_forward: bool = true
var can_player_jump: bool = true
var flipped: bool = false
var direction: float


func flip_character():
	if direction > 0:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction <  0:
		rotation = 0
		scale.y = 1
		flipped = false

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move_controlled_process(delta: float):
	apply_gravity(delta)
	flip_character()
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_player_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	direction = Input.get_axis("left", "right")	
	if direction and can_player_walk_forward: # can only walk if not too close to the wall
		velocity.x = direction * speed
	else: # speed 0 guard
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func is_controlled() -> bool:
	if Utils.has_child_of_type(self, Needle):
		return true
	else:
		return false


	
