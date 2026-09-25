extends State

var was_exited_at_least_once: bool = false

func enter() -> void:
	character.phase_out_horizontal_movement()
	if was_exited_at_least_once:
		character.animated_sprite.play('idle')
	
func exit() -> void:
	was_exited_at_least_once = true
	
func physics_update(delta: float) -> void:
	# Gravity
	character.apply_gravity(delta)
	
	# Shooting mechanics
	character.shoot_process()
	
	# Attacking mechanics
	character.attack_process()
	
	# Update physicks
	character.move_and_slide()
	
	# Jump
	if Input.is_action_just_pressed("jump") and character.can_jump():
		state_machine.transition_to("Jump")
		return
	
	# Walk
	if Input.get_axis("left", "right") != 0.0:
		state_machine.transition_to("Walk")
		return
		
	# Fall
	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	# Pickup mechanics
	character.pickup_process()
