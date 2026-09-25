extends Node


func is_body_a_tile_set_static(body: Node2D) -> bool:
	if body == null:
		return false
	if body.get_class() == "TileMapLayer":
		var tileset_collision_layer = body.tile_set.get_physics_layer_collision_layer(0)
		if tileset_collision_layer == 2:
			return true
	return false

func has_child_of_type(parent: Node, type: Variant) -> bool:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return true
	return false

func jump_height(jump_velocity: float, gravity: float) -> float:
	if gravity == 0.0:
		return 0.0
	return (jump_velocity * jump_velocity) / (2.0 * abs(gravity))

func air_time(jump_velocity: float, gravity: float) -> float:
	if gravity == 0.0:
		return 0.0
	return 2.0 * abs(jump_velocity) / abs(gravity)
	
func jump_length(speed: float, jump_velocity: float, gravity: float) -> float:
	return abs(speed) * air_time(jump_velocity, gravity)
