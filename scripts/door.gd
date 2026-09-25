extends Node2D

@export var opening_time: float = 1
var open_offset := Vector2(0, -64)
var tween: Tween
var is_open := false
var variant: float
var closed_pos
var open_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	closed_pos = position
	open_pos = position + open_offset
	call_deferred("set_color")
	
func set_color():
	if variant == 0:
		$AnimatedSprite2D.animation = "v0"
	elif variant == 1:
		$AnimatedSprite2D.animation = "v1"

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
