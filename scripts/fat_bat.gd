extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@export var initial_direction: float = -1.0
var can_aggro: bool
var tracked_player: Node2D
var projectile_direction: Vector2

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat

func set_x_dir_to_player():
	if tracked_player == null:
		direction = 1.0
		return	
	var arrow = (tracked_player.global_position - global_position)
	if arrow.x >= 0:
		direction = 1.0
	else:
		direction = -1.0

func _physics_process(delta: float) -> void:
	update_tracked_player()
	# print($StateMachine.current_state)

func move_controlled_process(delta: float):
	apply_gravity(delta)
	velocity.x = 0
	move_and_slide()

func update_tracked_player():
	tracked_player = $AggroModule.tracked_player
