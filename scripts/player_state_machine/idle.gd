# IdleState.gd
extends State

var is_action_playing: bool = false

func enter() -> void:
    character.phase_out_horizontal_movement()
    character.play_animation("idle")
    is_action_playing = false
    if not character.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        character.animated_sprite.animation_finished.connect(_on_animation_finished)

func exit() -> void:
    if character.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        character.animated_sprite.animation_finished.disconnect(_on_animation_finished)

func physics_update(delta: float) -> void:
    character.apply_gravity(delta)
    character.move_and_slide()

    # Handle Attacks / Throws
    if character.attack_process():
        character.play_animation("attack")
        is_action_playing = true
    elif character.shoot_process():
        character.play_animation("throw")
        is_action_playing = true

    # State Transitions
    if Input.is_action_just_pressed("jump") and character.can_jump():
        state_machine.transition_to("Jump")
        return

    if Input.get_axis("left", "right") != 0.0:
        state_machine.transition_to("Walk")
        return

    if not character.is_on_floor():
        state_machine.transition_to("Fall")
        return

    character.pickup_process()

func _on_animation_finished() -> void:
    if is_action_playing:
        is_action_playing = false
        character.play_animation("idle")