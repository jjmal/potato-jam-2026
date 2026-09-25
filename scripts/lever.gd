extends Interactible
class_name Lever

@export var trigger_time: float = 1.0
var permatriggered: bool = false
var pushed: bool = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not pushed or not permatriggered:
		triggered.emit()
		$TriggerTimer.start()
		pushed = true
		$AnimatedSprite2D.play()

func _on_trigger_timer_timeout() -> void:
	if not permatriggered:
		untriggered.emit()
		pushed = false
		$AnimatedSprite2D.play_backwards()
