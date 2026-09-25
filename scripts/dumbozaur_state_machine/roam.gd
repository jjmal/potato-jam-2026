extends State

func enter():
	pass

func physics_update(delta: float) -> void:
	character.roam_move_process(delta)
	
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return
