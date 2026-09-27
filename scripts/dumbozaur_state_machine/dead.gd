extends State

func enter():
	pass

func physics_update(delta: float) -> void:
	character.dead_process(delta)
