extends Node2D

var player_ref: CharacterBody2D

@export var item_id: String # Give every pickup a unique string ID in the Inspector

func _ready() -> void:
	if Globals.collected_items.has(item_id):
		queue_free() # Remove immediately if already picked up
		return
		
func _physics_process(delta: float) -> void:
		if player_ref != null and Input.is_action_just_pressed("pickup"):
			Globals.current_max_ammo += 1
			Globals.collected_items[item_id] = true
			player_ref.ammo += 1
			call_deferred("queue_free")

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_ref = null
	
