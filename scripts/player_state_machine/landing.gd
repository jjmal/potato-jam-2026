extends State


# Called when the node enters the scene tree for the first time.
func enter():
	character.animated_sprite.play('landing')
	await character.animated_sprite.animation_finished
	if state_machine.current_state == self:  
		# Idle
		if character.direction == 0.0:
			state_machine.transition_to("Idle")
			
		# Walking
		if character.direction != 0.0:
			state_machine.transition_to("Walk")
	
func physics_update(delta: float) -> void:
	#character.direction = Input.get_axis("left", "right")
	#
	## Shooting mechanics
	#character.shoot_process()
#
	## Walk mechanics
	#character.move_process(delta)
	#
	## Pickup mechanics
	#character.pickup_process()
	pass
