extends Interactible


func _on_trigger_area_body_entered(_body: Node2D) -> void:
	$AnimatedSprite2D.frame = 1
	triggered.emit()

func _on_trigger_area_body_exited(_body: Node2D) -> void:
	$AnimatedSprite2D.frame = 0
	untriggered.emit()
