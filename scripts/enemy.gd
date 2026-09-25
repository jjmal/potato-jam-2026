extends CharacterBody2D
class_name Enemy

@export var jump_velocity: float
@export var needle_pouch: Node
var speed: float
var can_player_walk_forward: bool = true
var can_player_jump: bool = true
var can_player_shoot: bool = true
var flipped: bool = false
var direction: float
@onready var needle_array = NeedleManager.needle_array
@onready var pickable_needle_array = NeedleManager.pickable_needle_array


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
		jump()

	direction = Input.get_axis("left", "right")	
	if direction and can_player_walk_forward: # can only walk if not too close to the wall
		velocity.x = direction * speed
	else: # speed 0 guard
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func jump():
	velocity.y = jump_velocity

func is_controlled() -> bool:
	if Utils.has_child_of_type(self, Needle):
		return true
	else:
		return false

func can_throw_needle() -> bool:
	if Utils.has_child_of_type(self, Needle):
		return true
	return false

func get_needle_to_throw() -> Needle:
	for child in get_children():
		if is_instance_of(child, Needle):
			return child
	return


func spawn_needle(direction_state: int):
	var needle = NeedleManager.create_needle(direction_state)
	var needle_spawn_position
	
	needle_pouch.add_child(needle)
	needle_spawn_position = $ShotMarker.global_position
	needle.global_position = needle_spawn_position
	
	
func throw_needle_process():
	var old_needle = get_needle_to_throw()
	print(can_player_shoot)
	if (Input.is_action_just_pressed("shoot_forward") or Input.is_action_just_pressed("shoot_up")) and can_player_shoot and old_needle != null:
		print('yay')
		if Input.is_action_just_pressed("shoot_forward"):
			if flipped:
				spawn_needle(Needle.RIGHT)
			else:
				spawn_needle(Needle.LEFT)
		elif Input.is_action_just_pressed("shoot_up"):
			spawn_needle(Needle.UP)
			
		NeedleManager.remove_needle(old_needle)
