extends State

# func play_anim_on_enter():
# 	character.animated_sprite.play("walk")
	
func enter() -> void:
	character.speed = character.roam_speed
	# call_deferred("play_anim_on_enter")
	if character.animated_sprite.animation != "attack":
		character.animated_sprite.play("walk")
func exit() -> void:
	pass


func physics_update(delta: float) -> void:
	character.move_roam_process(delta)
	# Controlled
	if character.is_controlled():
		state_machine.transition_to("Controlled")
		return
		
	if character.can_aggro:
		state_machine.transition_to("Aggro")
		return
	
	if not character.is_on_floor():
			character.animated_sprite.stop()
	else:
			character.animated_sprite.play("walk")

