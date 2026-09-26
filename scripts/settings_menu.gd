extends CanvasLayer


signal return_pressed


func _on_return_pressed() -> void:
	return_pressed.emit()
