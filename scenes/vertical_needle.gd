extends Needle
class_name VerticalNeedle

@onready var gravity = 980 * Vector2.DOWN

func _ready():
	super._ready()
	velocity = speed * direction

func set_flip():
	if velocity.y > 0:
		rotation = -PI/2
		flipped = false
	else:
		rotation =  PI/2
		flipped = true

func move(delta):
	if not collided:
		velocity += gravity * delta
		position += velocity * delta

func _physics_process(delta: float) -> void:
	set_flip()
	move(delta)
	set_ray_cast(velocity * delta)
	
	super._physics_process(delta)
