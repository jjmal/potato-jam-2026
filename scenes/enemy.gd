extends CharacterBody2D
const JUMP_VELOCITY = -400.0

@export var speed: int = 150
var controlled: bool = false
var direction = 1

func _ready() -> void:
	direction = 1

func _physics_process(delta: float) -> void:
	
	set_controlled()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controlled:
		setup_move_controlled()
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func setup_move_controlled():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")	
	
func _on_move_timer_timeout() -> void:
	if not controlled:
		direction = - direction

func set_controlled():
	if Utils.has_child_of_type(self, Needle):
		controlled = true
	else:
		controlled = false
		
	
