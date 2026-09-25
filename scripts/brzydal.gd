extends Enemy

const ORIGIN_TO_COLLISION_BOTTOM = 23

@onready var animated_sprite = $AnimatedSprite2D
@onready var roam_fall_detection_ray = $RoamFallDetectionRay
@onready var wall_detection_ray = $WallDetectionRay
@onready var spike_detection_ray = $SpikeDetectionRay
@export var roam_speed: float
@export var aggro_speed: float
@export var controlled_speed: float
@export var aggro_fall_ray_length: float = 128.0
@export var distance_for_turning: float = 64.0
@export var avg_random_jump_interval = 3.0

var can_aggro: bool
var tracked_player: Node2D
var walk_anim_play: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attack_on_cooldown: bool = false

func _ready() -> void:
	direction = -1.0
	$Hitbox/CollisionShape2D.disabled = true
	
func check_if_about_to_fall() -> bool:
	if not roam_fall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_about_to_hit_spikes() -> bool:
	if spike_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func check_if_about_to_hit_a_wall() -> bool:
	if wall_detection_ray.is_colliding() and is_on_floor():
		return true
	return false

func random_jump_process(delta):
	var probability_per_second = 1.0 / avg_random_jump_interval
	if randf() < probability_per_second * delta and can_jump():
		jump()

func can_jump() -> bool:
	return is_on_floor()
	
func move_forward_setup():
	velocity.x = direction * speed
	
func move_forward_with_jumps_process():
	var player_y_level = tracked_player.global_position.y
	var my_y_level = global_position.y 
	
	if can_jump() and player_y_level > my_y_level:
		jump()
	velocity.x = direction * speed


func move_roam_process(delta: float):
	apply_gravity(delta)
	flip_character()
	if check_if_about_to_fall() or check_if_about_to_hit_a_wall() or check_if_about_to_hit_spikes():
		direction = - direction
	move_forward_setup()
	move_and_slide()
	
	
func move_aggro_process(delta: float):
	apply_gravity(delta)
	set_x_dir_to_player()
	flip_character()
	if (check_if_about_to_fall() or check_if_about_to_hit_a_wall() or check_if_about_to_hit_spikes()) and can_jump():
		jump()
	random_jump_process(delta)
	move_forward_setup()
	move_and_slide()
	
	
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

func can_attack() -> bool:
	return not is_attack_on_cooldown
	
func _physics_process(delta: float) -> void:
	update_tracked_player()
	play_walk_animation()

func attack():
	is_attack_on_cooldown = true	
	$Hitbox/CollisionShape2D.disabled = false
	$AttackTimer.start()
	$AttackFramesTimer.start()

func attack_controlled_process():
	if Input.is_action_just_pressed("attack") and can_player_attack and can_attack():
		attack()

func play_walk_animation():
	if velocity.x != 0.0 and not walk_anim_play:
		animated_sprite.play('walk')
		walk_anim_play = true
	else:
		walk_anim_play = false
		animated_sprite.stop()

func _on_aggro_module_aggro_status(aggro_stat: bool) -> void:
	can_aggro = aggro_stat
	
func _on_attack_timer_timeout() -> void:
	is_attack_on_cooldown = false
	
func _on_attack_frames_timer_timeout() -> void:
	$Hitbox/CollisionShape2D.disabled = true
