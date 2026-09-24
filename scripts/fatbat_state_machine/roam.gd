extends State

func enter() -> void:
	character.animated_sprite.play("flying")

func physics_update(_delta: float) -> void:
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return
	# Aggro
	if character.can_aggro:
		state_machine.transition_to("Aggro")
		return
