extends State

func enter() -> void:
	character.speed = character.roam_speed
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return
		
	if character.can_aggro:
		state_machine.transition_to("Aggro")
		return
