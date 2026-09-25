extends Node

const VERTICAL_SCENE = preload("res://scenes/vertical_needle.tscn")
const HORIZONTAL_SCENE = preload("res://scenes/horizontal_needle.tscn")

var needle_array: Array= []
var pickable_needle_array: Array = []

func find_min_dist_pickable_needle():
	var val_arr = []
	for needle in pickable_needle_array:
		val_arr.append(needle.distance_to_tracked_player)
	var min_val = val_arr.min()
	for needle in pickable_needle_array:
		if needle.distance_to_tracked_player == min_val:
			return needle
	return

func create_needle(direction_state: int):
	var scene = PackedScene
	
	if direction_state == Needle.LEFT or direction_state == Needle.RIGHT:
		scene = HORIZONTAL_SCENE
	elif direction_state == Needle.UP:
		scene = VERTICAL_SCENE
	
	var needle = scene.instantiate()
	needle.direction_state = direction_state
	
	needle_array.append(needle)
	needle.pickup_status_has_changed.connect(_on_needle_pickup_status_has_changed)
	
	return needle

func remove_needle(needle):
	needle_array.erase(needle)
	pickable_needle_array.erase(needle)
	needle.call_deferred("queue_free")

func _on_needle_pickup_status_has_changed(needle: Needle, new_value: bool):
	if new_value == true:
		pickable_needle_array.append(needle)
	else:
		pickable_needle_array.erase(needle)
