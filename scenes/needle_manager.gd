extends  Node

var needle_array: Array[Needle] = []
var pickable_needle_array: Array[Needle] = []
var prev_len: int
var na_len: int

func find_min_dist_pickable_needle() -> Needle:
	var val_arr = []
	for needle in pickable_needle_array:
		val_arr.append(needle.distance_to_tracked_player)
	print(val_arr)
	return pickable_needle_array[0]
