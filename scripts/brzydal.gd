extends Enemy


@onready var animated_sprite = $AnimatedSprite2D
@onready var fall_detection_ray = $FallDetectionRay
@onready var wall_detection_ray = $WallDetectionRay
@export var roam_speed: float
@export var aggro_speed: float
@export var controlled_speed: float
@export var allow_jump: bool
var can_aggro: bool


func _ready() -> void:
	direction = -1.0

func move_roam_process(delta: float):
	apply_gravity(delta)
	flip_character()
	if check_if_about_to_fall() or check_if_about_to_hit_a_wall():
		direction = - direction
	move_forward()


func check_if_about_to_fall() -> bool:
	if not fall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false
	
func check_if_about_to_hit_a_wall() -> bool:
	if wall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func move_forward():
	velocity.x = direction * roam_speed
	move_and_slide()

func attack():
	pass

	
func move_aggro_process(delta: float):
	apply_gravity(delta)
	flip_character()
	
	

func _physics_process(delta: float) -> void:
	# print($StateMachine.current_state)
	print(direction)

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat
