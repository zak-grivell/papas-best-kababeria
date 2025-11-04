extends Area2D

class_name Draggable

@export var item_type: String = ""
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO

@export var on_spawn_drag: bool

var first_use = true

var meat_types = ["pork", "chicken", "beef", "lamb", "lamb_uncooked", "beef_uncooked", "chicken_uncooked", "pork_uncooked"]

func _ready() -> void:
	await get_tree().process_frame
	start_position = global_position
	if on_spawn_drag:
		dragging = true
		global_position = get_global_mouse_position()
		
func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_local_mouse_position()
			start_position = global_position
		else:
			if dragging:
				_try_drop()
			dragging = false


func _try_drop() -> void:
	var dropped: bool = false
	
	for area in get_overlapping_areas():
		if area.is_in_group("drop_zones") and item_type in area.accepts:
			global_position = area.global_position
			if area.has_signal("item_dropped"):
				area.emit_signal("item_dropped", self)
			dropped = true
			first_use = false
			break

	if not dropped:
		if item_type in meat_types:
			queue_free()
		global_position = start_position
