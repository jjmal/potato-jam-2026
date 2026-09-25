extends Node2D
class_name Interactible

var variant: float

signal triggered()
signal untriggered()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("set_color")

func set_color():
	if variant == 0:
		$AnimatedSprite2D.animation = "v0"
	elif variant == 1:
		$AnimatedSprite2D.animation = "v1"
