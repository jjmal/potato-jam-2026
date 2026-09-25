extends Node

@export var inputs: Array[Interactible]
@export var output: Node2D
@export var variant: float = 0
var nr_of_triggered: int = 0
var nr_of_inputs: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inputs.clear()
	for elem in inputs:
		if elem not in get_children():
			elem.reparent(self)
		elem.variant = variant
		elem.triggered.connect(_on_interactible_triggered)
		elem.untriggered.connect(_on_interactible_untriggered)
	
	nr_of_inputs = len(inputs)
	
	if output not in get_children():
		output.reparent(self)
	output.variant = variant

func _on_interactible_triggered():
	nr_of_triggered += 1
	if nr_of_triggered == nr_of_inputs:
		output.open()
		perma_trigger_input_levers()

func perma_trigger_input_levers():
	for elem in inputs:
		if elem is Lever:
			elem.permatriggered = true

func _on_interactible_untriggered():
	nr_of_triggered -= 1
	output.close()
