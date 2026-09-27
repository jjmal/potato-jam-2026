extends Node

var current_max_ammo: int
var current_level_idx: int = 0
var collected_items: Dictionary

func _init():
	current_max_ammo = 0
	current_level_idx = 0
