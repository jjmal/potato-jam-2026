extends  Node

var needle_array: Array[Needle] = []
var prev_len: int
var na_len: int

func _process(delta: float) -> void:
	print(needle_array.size())
