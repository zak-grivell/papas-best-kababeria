extends Area2D

@onready var parent = get_parent()
@export var placed = false

@onready var held_handler = get_node("/root/Node/TabContainer/Build Station/HoldingHandler")


var dragging = false
var old_pos = null

func _input_event(_viewport, event, _shape_idx):
	var pressed = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if pressed and not placed:
		add_to_group("spawned_wraps")
		parent.spawn_new_wrap(self)
		placed = true
	elif pressed and placed and not dragging and not held_handler.holding:
		held_handler.holding = true
		dragging = true
		old_pos = position
	elif dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		dragging = false
		held_handler.holding = false
		
		drag_ended()
	
func drag_ended():
	for area in get_overlapping_areas():
		if area.name == "Bin":
			queue_free()
			get_parent().delete_wrap(self)
			return
			
		if area.is_in_group("takeaway-box"):
			get_parent().delete_wrap(self)
			get_parent().remove_child(self)
			
			
			area.add_child(self)
			
			var tween := create_tween()
			
			var p = get_parent().position
			
			var new_box = load("res://build_station/takeaway_box.tscn").instantiate()
			
			new_box.position = Vector2(position.x, p.y + 500)
			
			get_parent().get_parent().add_child(new_box)
			
			var r = area.position
			
			
			tween.set_parallel()
			
			tween.tween_property(area, "position", r + Vector2(500, 0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(new_box, "position", p, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

			tween.play()
			
			
			position = Vector2(100, 20)
			return
			
	position = old_pos


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
