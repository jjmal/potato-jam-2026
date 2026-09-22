extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@export var roam_speed: float
@export var aggro_speed: float
@export var controlled_speed: float

func _physics_process(delta: float) -> void:
	print(direction)
