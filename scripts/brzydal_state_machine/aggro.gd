extends State

func enter() -> void:
	character.speed = character.aggro_speed
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	
	character.move_aggro_process(delta)
	
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return

func _on_aggro_module_drop_aggro() -> void:
	state_machine.transition_to("Roam")
