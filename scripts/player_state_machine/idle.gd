extends State

func enter() -> void:
	character.phase_out_horizontal_movement()
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	# Gravity
	character.apply_gravity(delta)
	
	# Pickup mechanics
	character.pickup_process()
	
	# Shooting mechanics
	character.shoot_process()
	
	# Jump
	if Input.is_action_just_pressed("jump") and character.can_jump():
		state_machine.transition_to("Jump")
		print('jump!')
		return
	
	# Walk
	if Input.get_axis("left", "right") != 0.0:
		state_machine.transition_to("Walk")
		return
		
	# Fall
	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return
