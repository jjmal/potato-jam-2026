extends Needle
class_name VerticalNeedle

@onready var gravity = 980 * Vector2.DOWN

func _ready():
	super._ready()
	velocity = speed * direction

func set_flip():
	if velocity.y > 0:
		rotation = -PI/2
		flipped = true
	else:
		rotation = PI/2
		flipped = false

func move(delta):
	if not collided:
		velocity += gravity * delta
		position += velocity * delta

func _physics_process(delta: float) -> void:
	set_flip()
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

func collide():
	collide_with_player_head()
	super.collide()
	
