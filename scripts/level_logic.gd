extends Node

signal switch_to_next_level
signal start_current_level

var player: CharacterBody2D
@onready var spawn_point = $PlayerRespawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_current_level.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		start_current_level.emit()

func _on_level_switch_area_body_entered(body: Node2D) -> void:
	switch_to_next_level.emit()
	
