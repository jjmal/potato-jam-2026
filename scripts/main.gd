extends Node

@onready var enemy_manager: EnemyManager = find_child("EnemyManager")
@onready var scene_handler = $SceneHandler
@onready var hud = $UI/HUD
@onready var player = $Player
var current_level
	

func _on_player_can_jump_status_change(can_jump_status: bool) -> void:
	if enemy_manager != null:
		for enemy in enemy_manager.enemies_array:
			enemy.can_player_jump = can_jump_status		

func _on_player_can_walk_forward_status_change(can_walk_forward_status: bool) -> void:
	if enemy_manager != null:
		for enemy in enemy_manager.enemies_array:
			enemy.can_player_walk_forward = can_walk_forward_status

func _on_player_can_shoot_status_change(can_shoot_status: bool) -> void:
	if enemy_manager != null:
		for enemy in enemy_manager.enemies_array:
			enemy.can_player_shoot = can_shoot_status

func _on_player_can_attack_status_change(can_attack_status: bool) -> void:
	if enemy_manager != null:
		for enemy in enemy_manager.enemies_array:
			enemy.can_player_attack = can_attack_status

func _on_player_ammo_changed(ammo: Variant) -> void:
	hud.set_deferred("ammo", ammo)

func _on_scene_handler_toggle_hud(to_on: bool) -> void:
	hud.set_deferred("visible", to_on)
		
func _on_scene_handler_loaded_level(level: Node2D) -> void:
	current_level = level
	var level_logic = level.find_child("LevelLogic")
	var character_marker_spawn_pos = level_logic.spawn_point
	level_logic.switch_to_next_level.connect(_on_current_level_logic_switch_to_next_level)
	level_logic.start_current_level.connect(_on_current_level_logic_start_current_level)
	player.global_position = character_marker_spawn_pos.global_position
	player.ammo = Globals.current_max_ammo

func clear_needles():
	for needle in player.needle_pouch.get_children():
		NeedleManager.remove_needle(needle)

func _on_current_level_logic_switch_to_next_level():
	clear_needles()
	scene_handler.next_level()
	
func _on_current_level_logic_start_current_level():
	clear_needles()
	scene_handler.restart()

func _on_player_joniec() -> void:
	scene_handler.restart()
