extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			child.character = get_parent()
	current_state = initial_state
	current_state.enter()

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)
	#if get_parent() is Enemy:
		#print(current_state)
		
func transition_to(state_name: String) -> void:
	var new_state = get_node(state_name) as State
	if new_state == null or new_state == current_state:
		return
	current_state.exit()
	current_state = new_state
	current_state.enter()
	
