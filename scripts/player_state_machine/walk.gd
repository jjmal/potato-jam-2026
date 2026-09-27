# WalkState.gd
extends State

var is_action_playing: bool = false

func enter() -> void:
    character.play_animation("walk")
    is_action_playing = false
    if not character.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        character.animated_sprite.animation_finished.connect(_on_animation_finished)

func exit() -> void:
    if character.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        character.animated_sprite.animation_finished.disconnect(_on_animation_finished)

func physics_update(delta: float) -> void:
    character.direction = Input.get_axis("left", "right")
    character.move_process(delta)

    
    if character.attack_process():
        character.play_animation("walk_attack")
        print("walk attack")
        is_action_playing = true
    elif character.shoot_process():
        character.play_animation("walk_throw")
        print("walk throw")
        is_action_playing = true


    if character.direction == 0.0:
        state_machine.transition_to("Idle")
        return

    if Input.is_action_just_pressed("jump") and character.can_jump():
        state_machine.transition_to("Jump")
        return

    if not character.is_on_floor():
        state_machine.transition_to("Fall")
        return

    character.pickup_process()

func _on_animation_finished() -> void:
    if is_action_playing:
        is_action_playing = false
        character.play_animation("walk")