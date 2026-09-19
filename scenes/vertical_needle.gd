extends Needle
class_name VerticalNeedle

@onready var gravity = 1000 * Vector2.DOWN
var is_on_ramp: bool = false


func _ready():
	super._ready()
	velocity = speed * direction

func set_flip():
	if velocity.y > 0 or is_on_ramp:
		rotation = -PI/2
		flipped = true
	else:
		rotation = PI/2
		flipped = false

func move(delta):
	if not collided:
		velocity += gravity * delta
		if is_on_ramp:
			move_and_slide()
		else:
			position += velocity * delta

func _physics_process(delta: float) -> void:
	set_flip()
	check_for_ramp_collition(delta)
	move(delta)
	set_ray_cast(velocity * delta)
	
	super._physics_process(delta)

func collide_with_player_head():
	hit_ray.force_raycast_update()
	if check_if_collision_occurs() and flipped:
		if get_hit_ray_collision()[0] == COLLIDER_PLAYER_HEAD:
			resolve_collision()
			var collider = get_hit_ray_collision()[1]
			self.reparent(collider)
	
func check_for_ramp_collition(delta):
	if move_and_collide(velocity * delta, true):
		is_on_ramp = true
	else:
		is_on_ramp = false

func collide():
	collide_with_player_head()
	super.collide()
	
