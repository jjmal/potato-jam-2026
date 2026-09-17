extends Control

signal new_game_pressed(origin: String)
signal continue_pressed(origin: String)
signal exit_pressed(origin: String)
signal settings_pressed(origin: String)

func _on_continue_pressed() -> void:
	continue_pressed.emit("main_menu")


func _on_settings_pressed() -> void:
	settings_pressed.emit("main_menu")


func _on_new_game_pressed() -> void:
	new_game_pressed.emit("main_menu")



func _on_exit_pressed() -> void:
	# Debug code
	# print("BUTTON INSTANCE: ", get_instance_id())
	# print("EXIT CONNECTIONS: ", exit_pressed.get_connections())
	exit_pressed.emit("main_menu")