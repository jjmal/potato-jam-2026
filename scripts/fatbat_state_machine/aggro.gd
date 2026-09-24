extends State


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float) -> void:
	character.set_x_dir_to_player()
	character.flip_character()
	
	
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return
	

func _on_aggro_module_drop_aggro() -> void:
	state_machine.transition_to("Roam")
