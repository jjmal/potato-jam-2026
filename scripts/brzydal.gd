extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var roam_fall_detection_ray = $RoamFallDetectionRay
@onready var aggro_fall_detection_ray = $AggroFallDetectionRay
@onready var wall_detection_ray = $WallDetectionRay
@onready var jump_length_ray = $JumpLengthRay
@export var roam_speed: float
@export var aggro_speed: float
@export var controlled_speed: float
@export var aggro_fall_ray_length: float = 40.0
@export var distance_for_turning: float = 64.0
@export var distance_for_follow_jumping: float = 64.0

var can_aggro: bool
var tracked_player: Node2D
var walk_anim_play: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_aggro_frustrated_jump: bool

func _ready() -> void:
	direction = -1.0

	
func check_if_about_to_fall() -> bool:
	if not roam_fall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_unsafe_fall_for_aggro() -> bool:
	if not aggro_fall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_about_to_hit_a_wall() -> bool:
	if wall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_can_make_jump() -> bool:
	if jump_length_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_player_too_close_to_follow_jump() -> bool:
	var arrow = (tracked_player.global_position - global_position)
	if abs(arrow.x) < distance_for_turning:
		return  true
	return false

func can_jump() -> bool:
	return is_on_floor()
	

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
	
func frustrated_jump():
	if can_jump():
		jump()
		can_aggro_frustrated_jump = false
		$AggroFrustratedJumpTimer.start()


func aggro_frustrated_process(delta):
	frustrated_jump()
	

func move_aggro_process(delta: float):
	apply_gravity(delta)
	set_x_dir_to_player()
	flip_character()
	
	var unsafe_fall_for_aggro = false
	var is_at_ledge = false
	var is_at_wall = false
	
	if not roam_fall_detection_ray.is_colliding():
		is_at_ledge = true
		
	if is_at_ledge and check_if_unsafe_fall_for_aggro():
		unsafe_fall_for_aggro = true
		if not check_if_can_make_jump():
			aggro_frustrated_process(delta)
		else:
			if can_jump() and not check_if_player_too_close_to_follow_jump():
				jump()
			move_forward()
	
	elif is_at_ledge and not check_if_unsafe_fall_for_aggro():
		var fall_y_level = jump_length_ray.get_collision_point().y
		var player_y_level = tracked_player.global_position.y
		var my_y_level = global_position.y
		

		if abs(my_y_level - player_y_level) > abs(player_y_level - fall_y_level):
			move_forward()
		else:
			if can_jump():
				jump()
			move_forward()
	
	
	
	if not is_at_ledge and not is_at_wall:
		move_forward()
		
		
	

func set_x_dir_to_player():
	if tracked_player == null:
		return	
	
	var arrow = (tracked_player.global_position - global_position)
	if abs(arrow.x) < distance_for_turning:
		return
	
	if arrow.x >= 0:
		direction = 1.0
	else:
		direction = -1.0


func update_tracked_player():
	tracked_player = $AggroModule.tracked_player


func _physics_process(delta: float) -> void:
	update_tracked_player()
	play_walk_animation()
	jump_length_ray.target_position.x = - Utils.jump_length(speed, jump_velocity, gravity)
	
func play_walk_animation():
	if velocity.x != 0.0 and not walk_anim_play:
		animated_sprite.play('walk')
		walk_anim_play = true
	else:
		walk_anim_play = false
		animated_sprite.stop()

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat

func _on_aggro_frustrated_jump_timer_timeout() -> void:
	can_aggro_frustrated_jump = true
