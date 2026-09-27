# FallState.gd
extends State

var is_action_playing: bool = false

func enter() -> void:
    character.play_animation("fall")
    is_action_playing = false

func physics_update(delta: float) -> void:
    character.direction = Input.get_axis("left", "right")
    character.move_process(delta)

    if character.attack_process():
        character.play_animation("fall_attack") # or jump_attack if fall_attack doesn't exist
        print("fall attack")
        is_action_playing = true
    elif character.shoot_process():
        character.play_animation("fall_throw")
        print("fall throw")
        is_action_playing = true

    if character.is_on_floor():
        if character.direction == 0.0:
            state_machine.transition_to("Idle")
        else:
            state_machine.transition_to("Walk")