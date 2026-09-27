extends State


func physics_update(delta: float) -> void:
	character.move_controlled_process(delta)
	character.throw_needle_process()
	
	# Roam
	if not character.is_controlled():
		state_machine.transition_to("Roam")
		return
	if not character.is_on_floor():
			character.animated_sprite.stop()
	else:
			character.animated_sprite.play("walk")