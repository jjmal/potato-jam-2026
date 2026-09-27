extends State

func enter():
	call_deferred("play_anim_on_enter")
	

func physics_update(delta: float) -> void:
	character.roam_move_process(delta)
	
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return

	# if not character.is_on_floor():
	# 		character.animated_sprite.stop()
	# else:
	# 		character.animated_sprite.play("walk")

func play_anim_on_enter():
	character.animated_sprite.play("walk")
