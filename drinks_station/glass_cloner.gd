extends Control

func clone_me(node: Node):
	var clone := node.duplicate()
	clone.visible = false
	add_child(clone)
	
func finished_moved():
	for child in get_children():
		child.visible = true
	
