extends  Node

var needle_array: Array= []
var pickable_needle_array: Array = []
var prev_len: int
var na_len: int

func find_min_dist_pickable_needle():
	var val_arr = []
	for needle in pickable_needle_array:
		val_arr.append(needle.distance_to_tracked_player)
	var min_val = val_arr.min()
	for needle in pickable_needle_array:
		if needle.distance_to_tracked_player == min_val:
			return needle
	return
