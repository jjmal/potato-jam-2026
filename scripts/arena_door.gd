extends StaticBody2D


@export var enemy_manager: EnemyManager
@export var opening_time: float = 1
var open_offset := Vector2(0, -64)
var tween: Tween
var is_open := false
var closed_pos
var open_pos


func _ready() -> void:
	closed_pos = position
	open_pos = position + open_offset
	
func check_if_all_enemies_dead() -> bool:
	for enemy in enemy_manager.enemies_array:
		var enemy_state_machine = enemy.find_child("StateMachine")
		if enemy_state_machine.current_state.name != "Dead":
			return false
	return true

func _physics_process(delta: float) -> void:
	if check_if_all_enemies_dead():
		open()
	else:
		close()

func open():
	if is_open:
		return
	is_open = true
	run_tween(open_pos)

func close():
	if not is_open:
		return
	is_open = false
	run_tween(closed_pos)


func rescale_duration_by_progress(target_offset) -> float:
	var full_dist = abs(open_offset.y)
	var progress_dist = abs(position.y - target_offset.y)
	return opening_time * (progress_dist/full_dist)
	

func run_tween(target_offset: Vector2):
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var duration = rescale_duration_by_progress(target_offset)
	
	tween.tween_property(self, "position", target_offset, duration)
