extends CharacterBody2D

const COLLIDER_NONE = 0
const COLLIDER_STATIC = 2

@export var speed = 1000
@export var fixed_depth = -8.0
@onready var hit_ray = $OtherCollisions/HitRay

var direction_state: String
var direction: Vector2
#var collision_platform_enabled: bool = false
var flipped: bool = false

func _ready() -> void:
	direction = get_direction()
	disable_collision_platform()
	set_flip()
	
func get_direction():
	if direction_state == "left":
		return Vector2.LEFT
	elif direction_state == "right":
		return Vector2.RIGHT

func set_ray_cast(vel: Vector2):
	hit_ray.target_position = hit_ray.to_local(global_position + vel)

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	position += velocity
	set_ray_cast(velocity)
	collide()
	
func disable_collision_platform():
	$CollisionPlatform.disabled = true

func enable_collision_platform():
	$CollisionPlatform.disabled = false
	
func set_flip():
	if direction_state == "right":
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction_state == "left":
		rotation = 0
		scale.y = 1
		flipped = false

func get_hit_ray_collision() -> int:
	hit_ray.force_raycast_update()
	if hit_ray.is_colliding():
		var collider = hit_ray.get_collider()
		if Utils.is_body_a_tile_set_static(collider):
			return COLLIDER_STATIC
	return COLLIDER_NONE
		
func collide():
	if get_hit_ray_collision() == COLLIDER_STATIC:
		var hit_point = hit_ray.get_collision_point()
		var hit_normal = hit_ray.get_collision_normal()
		global_position = hit_point - hit_normal * fixed_depth
		speed = 0
