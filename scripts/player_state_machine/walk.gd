extends State

func enter() -> void:
	var direction := Input.get_axis("left", "right")
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	
	# Walk mechanics
	character.apply_gravity(delta)
	character.flip_character(direction)
	
	# Idle:
	if Input.get_axis("left", "right") == 0.0:
		state_machine.transition_to("Idle")
		return
