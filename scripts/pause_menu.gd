extends CanvasLayer

signal resume_pressed(origin:String)
signal settings_pressed(origin:String)
signal exit_to_menu_pressed(origin:String)


func _on_resume_pressed() -> void:
	resume_pressed.emit("pause_menu")


func _on_settings_pressed() -> void:
	settings_pressed.emit("pause_menu")


func _on_exit_to_menu_pressed() -> void:
	exit_to_menu_pressed.emit("pause_menu")

