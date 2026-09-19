extends CharacterBody2D
const JUMP_VELOCITY = -400.0

@export var speed: int = 150
var controlled: bool = false
var direction = 1
var can_player_walk_forward: bool = true
var can_player_jump: bool = true

func _physics_process(delta: float) -> void:
	
	set_controlled()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controlled:
		setup_move_controlled()
	else:
		setup_move_free()
	
	move_and_slide()
	
func move():
	if controlled:
		setup_move_controlled()
	else:
		setup_move_free()

func setup_move_controlled():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_player_jump:
		velocity.y = JUMP_VELOCITY
	
	direction = Input.get_axis("left", "right")	
	if direction and can_player_walk_forward: # can only walk if not too close to the wall
		velocity.x = direction * speed
	else: # speed 0 guard
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
func setup_move_free():
	velocity.x = direction * speed
	
func _on_move_timer_timeout() -> void:
	if not controlled:
		direction = - direction

func set_controlled():
	if Utils.has_child_of_type(self, Needle):
		controlled = true
	else:
		controlled = false
		
	
