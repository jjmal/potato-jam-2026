extends State



func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	character.move_controlled_process(delta)
	if not character.is_controlled():
		if character.can_aggro:
			state_machine.transition_to("Aggro")
			return
		else:
			state_machine.transition_to("Roam")
			return
		
