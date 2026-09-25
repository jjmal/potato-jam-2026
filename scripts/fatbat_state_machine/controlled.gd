extends State


func enter() -> void:
	character.animated_sprite.pause()

func exit() -> void:
	character.animated_sprite.play()
	
func physics_update(delta: float) -> void:
	character.move_controlled_process(delta)
	character.throw_needle_process()
	if not character.is_controlled():
		# Aggro
		if character.can_aggro:
			state_machine.transition_to("Aggro")
			return
		
		# Roam
		else:
			state_machine.transition_to("Roam")
			return
