extends Sprite2D

@export var item_type: String = ""
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().process_frame
	start_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if texture:
				var tex_size: Vector2 = texture.get_size() * global_scale
				var rect := Rect2(global_position - tex_size * 0.5, tex_size)
				if rect.has_point(event.position):
					dragging = true
					drag_offset = event.position - global_position
		else:
			if dragging:
				_try_drop()
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position - drag_offset


func _try_drop() -> void:
	var zones: Array = get_tree().get_nodes_in_group("drop_zones")
	var dropped: bool = false

	for zone in zones:
		if zone is Area2D:
			var shape: CollisionShape2D = zone.get_node_or_null("CollisionShape2D")
			if shape and shape.shape:
				# Get the zone's bounding box in global space
				var zone_rect: Rect2 = shape.shape.get_rect()  # explicit type
				var transformed_rect: Rect2 = Rect2(shape.global_position - zone_rect.size * 0.5, zone_rect.size)
				if item_type in zone.accepts:
					if transformed_rect.has_point(global_position):
						global_position = zone.global_position
						if zone.has_signal("item_dropped"):
							zone.emit_signal("item_dropped", self)
						dropped = true
						break

	if not dropped:
		global_position = start_position
