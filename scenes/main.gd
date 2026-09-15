extends Node2D

const NeedlePreload: PackedScene = preload("res://scenes/needle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_needle_shot_forward(needle_spawn_pos, direction_state) -> void:
	var needle = NeedlePreload.instantiate()
	needle.global_position = needle_spawn_pos
	needle.direction_state = direction_state
	add_child(needle)
	needle.collide_with_enemy.connect(_on_needle_collide_with_enemy)
	
func _on_needle_collide_with_enemy(collider: Node, needle: Node):
	needle.reparent(collider)
	
