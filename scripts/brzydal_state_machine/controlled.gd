extends State



func enter() -> void:
	character.speed = character.controlled_speed
	
func exit() -> void:
	pass
	
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
		
