extends Area2D

var placed = false

func _process(_delta: float) -> void:
	if placed:
		return
		
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		global_position = get_global_mouse_position()
	else:
		for area in get_overlapping_areas():
			if area.is_in_group("spawned_wraps"):
				placed = true
				var current_parent = get_parent()
				
				var glo = global_position
				
				if current_parent:
					current_parent.remove_child(self)
				
				area.add_child(self)
				monitoring = false
				monitorable = false

				self.global_position = glo
			
		if placed == false:
			queue_free()
