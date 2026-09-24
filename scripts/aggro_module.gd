extends Node2D

@export var character: Node2D

@onready var wall_detection_ray: RayCast2D = $WallPlayerDetectionRay
var tracked_player: Node2D = null
var aggro_stat: bool = false
var is_ray_tracking_player: bool = false

signal aggro_status(aggro_stat: bool)
signal drop_aggro


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	update_aggro_process()
	aggro_status.emit(aggro_stat)

func update_aggro_process():
	if is_ray_tracking_player:
		wall_detection_ray.target_position = to_local(tracked_player.global_position)
		wall_detection_ray.force_raycast_update()
		
		if wall_detection_ray.is_colliding():
			aggro_stat = false
		else:
			aggro_stat = true
	else:
		aggro_stat = false

func _on_player_initial_detection_body_entered(body: Node2D) -> void:
	tracked_player = body
	is_ray_tracking_player = true
	
func _on_player_initial_detection_body_exited(body: Node2D) -> void:
	is_ray_tracking_player = false
	
func _on_player_drop_aggro_body_exited(_body: Node2D) -> void:
	drop_aggro.emit()
	tracked_player = null
