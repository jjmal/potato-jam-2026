extends State

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return

func _on_player_drop_aggro_body_exited(_body: Node2D) -> void:
	# Roam
	state_machine.transition_to("Roam")
