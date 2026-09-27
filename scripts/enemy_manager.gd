extends Node

var enemies_array: Array[Node] = []

func _on_child_entered_tree(node: Node) -> void:
	enemies_array.append(node)
	
func _on_child_exiting_tree(node: Node) -> void:
	enemies_array.erase(node)
