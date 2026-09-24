extends Enemy


@onready var animated_sprite = $AnimatedSprite2D
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
	
#func move_aggro_process(delta: float):
	#apply_gravity(delta)
	#flip_character()
	## movement
	#direction = 

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat
