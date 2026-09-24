extends Needle
class_name HorizontalNeedle


func _physics_process(delta: float) -> void:
	move(delta)
	set_ray_cast(velocity)
	
	super._physics_process(delta)

func move(delta):
	velocity = direction * speed * delta
	position += velocity

func collide():
	collide_enable_collision()
	super.collide()
	
func collide_enable_collision():
	hit_ray.force_raycast_update()
	if check_if_collision_occurs():
		if get_hit_ray_collision()[0] == COLLIDER_STATIC:
			enable_collision_platform()
		elif get_hit_ray_collision()[0] == COLLIDER_ENEMY:
			enable_collision_platform()

func set_flip():
	if direction_state == RIGHT:
		rotation = PI
		scale.y = -1
		flipped = true
	elif direction_state == LEFT:
		rotation = 0
		scale.y = 1
		flipped = false
