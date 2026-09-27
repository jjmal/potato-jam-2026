extends State


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float) -> void:
	character.dead_process(delta)
