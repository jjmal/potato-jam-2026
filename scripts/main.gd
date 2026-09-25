extends Node2D
	
func _on_player_can_jump_status_change(can_jump_status: bool) -> void:
	for enemy in $EnemyManager.enemies_array:
		enemy.can_player_jump = can_jump_status

func _on_player_can_walk_forward_status_change(can_walk_forward_status: bool) -> void:
	for enemy in $EnemyManager.enemies_array:
		enemy.can_player_walk_forward = can_walk_forward_status

func _on_player_can_shoot_status_change(can_shoot_status: bool) -> void:
	for enemy in $EnemyManager.enemies_array:
		enemy.can_player_shoot = can_shoot_status

func _on_player_can_attack_status_change(can_attack_status: bool) -> void:
	for enemy in $EnemyManager.enemies_array:
		enemy.can_player_attack = can_attack_status
