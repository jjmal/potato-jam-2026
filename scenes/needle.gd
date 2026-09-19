extends CharacterBody2D
class_name Needle

const COLLIDER_NONE = 0
const COLLIDER_STATIC = 2
const COLLIDER_ENEMY = 3

const LEFT = 0
const UP = 1
const RIGHT = 2


@export var speed = 1000
@export var fixed_depth = -8.0
@onready var hit_ray = $Collisions/HitRay
@onready var pickup_ray = $Collisions/PickupRay
@onready var collision_platform = $Collisions/CollisionPlatformBody/CollisionPlatform

signal pickup_status_has_changed(itself: Needle, new_value: bool)


var direction_state: int
var direction: Vector2
var flipped: bool = false
var tracked_player: Node2D = null
var distance_to_tracked_player: float = INF
var collided: bool = false

var can_be_picked_up: bool = false: # only emit the signal if the value has changed
	set(new_value):
		if can_be_picked_up == new_value:
			return
		can_be_picked_up = new_value
		pickup_status_has_changed.emit(self, new_value)

func _ready() -> void:
	direction = get_direction()
	disable_collision_platform()
	velocity = direction * speed
	
func get_direction():
	if direction_state == LEFT:
		return Vector2.LEFT
	elif direction_state == RIGHT:
		return Vector2.RIGHT
	elif direction_state == UP:
		return Vector2.UP

func set_ray_cast(vel: Vector2):
	hit_ray.target_position = hit_ray.to_local(global_position + vel)

func _physics_process(delta: float) -> void:
	
	if direction_state == UP:
		move_vertically(delta)
		set_ray_cast(velocity * delta)
	else:
		move_horizontally(delta)
		set_ray_cast(velocity)
	
	set_flip()
	
	collide()
	can_be_picked_up = check_if_can_pickup_with_ray()
	if can_be_picked_up:
		set_distance_to_tracked_player()

func move_horizontally(delta):
	velocity = direction * speed * delta
	position += velocity
	
func move_vertically(delta):
	if not collided:
			velocity += get_gravity() * delta
			position += velocity * delta

func disable_collision_platform():
	collision_platform.set_deferred("disabled", true)

func enable_collision_platform():
	collision_platform.set_deferred("disabled", false)
	
func set_flip():
	if direction_state == RIGHT:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction_state == LEFT:
		rotation = 0
		scale.y = 1
		flipped = false
	elif direction_state == UP:
		if velocity.y > 0:
			rotation = -PI/2
		else:
			rotation =  PI/2

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
	if not collided:
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
			self.reparent(collider)
			collided = true

func check_if_can_pickup_with_ray() -> bool:
	if not collided:
		return false
	
	if tracked_player != null:
		pickup_ray.target_position = to_local(tracked_player.global_position)
		pickup_ray.force_raycast_update()
		if pickup_ray.is_colliding():
			return false
		else:
			return true
	else:
		return false

func set_distance_to_tracked_player():
	distance_to_tracked_player = tracked_player.global_position.distance_to(global_position)

func _on_pickup_range_area_entered(area: Area2D) -> void: # May need to be reworked - terrible patern...
	tracked_player = area.get_parent()
	
func _on_pickup_range_area_exited(_area: Area2D) -> void:
	tracked_player = null
