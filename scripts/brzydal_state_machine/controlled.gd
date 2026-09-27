extends State


func enter() -> void:
	character.speed = character.controlled_speed
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
	character.attack_controlled_process()
	
	if character.animated_sprite.animation != "attack":
		if not character.is_on_floor():
			character.animated_sprite.stop()
		elif character.animated_sprite.animation != "attack":
				character.animated_sprite.play("walk")
			
	if not character.is_controlled():
		# Aggro
		if character.can_aggro:
			state_machine.transition_to("Aggro")
			return
		
		# Roam
		else:
			state_machine.transition_to("Roam")
			return
