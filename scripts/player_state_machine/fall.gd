extends State


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	character.animated_sprite.play('fall')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float) -> void:
	
	character.direction = Input.get_axis("left", "right")
	
	# Shooting mechanics
	character.shoot_process()
	
	# Walk mechanics
	character.move_process(delta)
	
	# Idle
	if character.is_on_floor() and character.direction == 0.0:
		state_machine.transition_to("Idle")
		
	# Walking
	if character.is_on_floor() and character.direction != 0.0:
		state_machine.transition_to("Walk")
