extends CharacterBody2D
class_name Needle

const COLLIDER_NONE = 0
const COLLIDER_STATIC = 2
const COLLIDER_ENEMY = 3

@export var speed = 1000
@export var fixed_depth = -8.0
@onready var hit_ray = $Collisions/HitRay
@onready var pickup_ray = $Collisions/PickupRay
@onready var collision_platform = $Collisions/CollisionPlatformBody/CollisionPlatform

signal collide_with_enemy(enemy: Node, itself: Node)
signal available_for_pickup(distance: float, itself: Node)

var direction_state: String
var direction: Vector2
var flipped: bool = false
var tracked_player: Node2D = null
var collided: bool = false

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
	send_signal_enable_pickup()
	
func disable_collision_platform():
	collision_platform.set_deferred("disabled", true)

func enable_collision_platform():
	collision_platform.set_deferred("disabled", false)
	
func set_flip():
	if direction_state == "right":
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction_state == "left":
		rotation = 0
		scale.y = 1
		flipped = false

func get_hit_ray_collision() -> Array:
	hit_ray.force_raycast_update()
	if hit_ray.is_colliding():
		var collider = hit_ray.get_collider()
		if Utils.is_body_a_tile_set_static(collider):
			return [COLLIDER_STATIC, collider]
		if collider.is_in_group("Enemy"):
			return [COLLIDER_ENEMY, collider]
		
	return [COLLIDER_NONE, null]
		
func collide():
	if get_hit_ray_collision()[0] == COLLIDER_STATIC:
		var hit_point = hit_ray.get_collision_point()
		var hit_normal = hit_ray.get_collision_normal()
		global_position = hit_point - hit_normal * fixed_depth
		speed = 0
		enable_collision_platform()
		collided = true
	
	elif get_hit_ray_collision()[0] == COLLIDER_ENEMY:
		var hit_point = hit_ray.get_collision_point()
		var hit_normal = hit_ray.get_collision_normal()
		global_position = hit_point - hit_normal * fixed_depth
		speed = 0
		var collider = get_hit_ray_collision()[1]
		collide_with_enemy.emit(collider, self)
		collided = true

func track_if_can_pickup_with_ray() -> bool:
	if not collided:
		return false
	
	if tracked_player != null:
		hit_ray.target_position = to_local(tracked_player.global_position)
		hit_ray.force_raycast_update()
		if hit_ray.is_colliding():
			return false
		else:
			return true
	else:
		return false

func send_signal_enable_pickup():
	if track_if_can_pickup_with_ray():
		print('can be picked up')
		var dist = global_position.distance_to(tracked_player.global_position)
		available_for_pickup.emit(dist, self)

func _on_pickup_range_body_entered(body: Node2D) -> void:
	tracked_player = body
	

func _on_pickup_range_body_exited(_body: Node2D) -> void:
	tracked_player = null
