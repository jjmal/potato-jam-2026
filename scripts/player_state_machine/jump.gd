# JumpState.gd
extends State

var is_action_playing: bool = false

func enter() -> void:
    character.velocity.y = character.JUMP_VELOCITY
    character.play_animation("jump")
    is_action_playing = false

func physics_update(delta: float) -> void:
    character.direction = Input.get_axis("left", "right")
    character.move_process(delta)

    # Air Attacks / Throws
    if character.attack_process():
        character.play_animation("jump_attack")
        print("jump attack")
        is_action_playing = true
    elif character.shoot_process():
        character.play_animation("jump_throw")
        print("jump throw")
        is_action_playing = true

    # Transitions
    if character.is_on_floor():
        if character.direction == 0.0:
            state_machine.transition_to("Idle")
        else:
            state_machine.transition_to("Walk")
        return

    if character.velocity.y > 0 and not is_action_playing:
        state_machine.transition_to("Fall")