extends Node

func is_body_a_tile_set_static(body: Node2D) -> bool:
	if body.get_class() == "TileMapLayer":
		var tileset_collision_layer = body.tile_set.get_physics_layer_collision_layer(0)
		if tileset_collision_layer == 2:
			return true
	return false
