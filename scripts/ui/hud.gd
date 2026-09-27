extends Control

var slot_array: Array = []
var ammo: int:
	set(value):
		ammo = value
		for slot in slot_array:
			slot.visible = true
		for slot in slot_array.slice(value):
			slot.visible = false
		

func _ready():
	for child in $Bar.get_children():
		if child.is_in_group("HudSlot"):
			slot_array.append(child)



	
	
