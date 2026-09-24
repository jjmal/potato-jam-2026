extends State



func enter() -> void:
	character.speed = character.controlled_speed
	
func exit() -> void:
	if character.direction == 0.0:
		if character.flipped:
			character.direction = 1.0
		else:
			character.direction = -1.0
	
func physics_update(delta: float) -> void:
	character.move_controlled_process(delta)
	if not character.is_controlled():
		# Aggro
		if character.can_aggro:
			state_machine.transition_to("Aggro")
			return
		
		# Roam
		else:
			state_machine.transition_to("Roam")
			return
		
