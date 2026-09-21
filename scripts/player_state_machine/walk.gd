extends State

func enter() -> void:
	character.animated_sprite.play('walk')
	
func exit() -> void:
	character.animated_sprite.stop()
	
func physics_update(delta: float) -> void:
	
	character.direction = Input.get_axis("left", "right")
	
	# Pickup mechanics
	character.pickup_process()
	
	# Shooting mechanics
	character.shoot_process()
	
	# Walk mechanics
	character.move_process(delta)
	
	# Idle:
	if Input.get_axis("left", "right") == 0.0:
		state_machine.transition_to("Idle")
		return
		
	# Jump
	if Input.is_action_just_pressed("jump") and character.can_jump():
		state_machine.transition_to("Jump")
		return
		
	# Fall
	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return
