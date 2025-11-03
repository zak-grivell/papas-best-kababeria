extends Area2D

@export var place_sprite: CompressedTexture2D


func _input_event(_viewport, event, _shape_idx):
	var pressed = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if pressed:
		var topping = load("res://build_station/topping.tscn").instantiate()
		
		topping.get_node("Sprite2D").texture = place_sprite
		
		add_child(topping)
