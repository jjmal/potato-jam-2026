extends State

func enter() -> void:
	Utils.set_outline(character, true)
func exit() -> void:
	if character.direction == 0.0:
		if character.flipped:
			character.direction = 1.0
		else:
			character.direction = -1.0
	Utils.set_outline(character, false)
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
