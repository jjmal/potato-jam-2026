extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var fall_detection_ray = $FallDetectionRay
@onready var wall_detection_ray = $WallDetectionRay
@export var roam_speed: float
@export var aggro_speed: float
@export var controlled_speed: float
@export var allow_jump: bool
var can_aggro: bool
var tracked_player: Node2D
var walk_anim_play: bool = false
var can_turn_in_pursuit: bool = true
var turn_delay = 0.3
var turn_delay_cooldown = 0.0
	
func _ready() -> void:
	direction = -1.0

func check_if_about_to_fall() -> bool:
	if not fall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false
	
func check_if_about_to_hit_a_wall() -> bool:
	if wall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func move_forward():
	velocity.x = direction * speed
	move_and_slide()

func attack():
	pass

func move_roam_process(delta: float):
	apply_gravity(delta)
	flip_character()
	if check_if_about_to_fall() or check_if_about_to_hit_a_wall():
		direction = - direction
	move_forward()
	
func move_aggro_process(delta: float):
	apply_gravity(delta)
	update_turn_delay_cooldown(delta)
	set_x_dir_to_player()
	
	flip_character()
	move_forward()

func set_x_dir_to_player():
	if tracked_player == null:
		return	
	if turn_delay_cooldown > 0:
		return
	if not can_turn_in_pursuit:
		return
	
	var arrow = (tracked_player.global_position - global_position)
	
	if arrow.x >= 0:
		direction = 1.0
	else:
		direction = -1.0
	turn_delay_cooldown = turn_delay 
	$PursuitTurnTimer.start()
	can_turn_in_pursuit = false

func update_tracked_player():
	tracked_player = $AggroModule.tracked_player

func update_turn_delay_cooldown(delta):
	turn_delay_cooldown = max(turn_delay_cooldown - delta, 0.0)

func _physics_process(delta: float) -> void:
	update_tracked_player()
	play_walk_animation()
	#print(tracked_player)
	#print($StateMachine.current_state)

func play_walk_animation():
	if velocity.x != 0.0 and not walk_anim_play:
		animated_sprite.play('walk')
		walk_anim_play = true
	else:
		walk_anim_play = false
		animated_sprite.stop()

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat


func _on_timer_timeout() -> void:
	can_turn_in_pursuit = true
