extends Area2D

@export var color: Color

@onready var held_handler = get_node("/root/Node/TabContainer/Build Station/HoldingHandler")


var left = false

func _ready() -> void:
	held_handler.holding = true

func is_back_home():
	for area in get_overlapping_areas():
		if area.name == "Sauces":
			return true
	return false

var current_line = null

func create_sauce_line(w):
	var line = Line2D.new()
	w.add_child(line)
	line.width = 20
	line.default_color = color
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	return line

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		for area in get_overlapping_areas():
			if area.is_in_group("spawned_wraps"):
				if current_line == null:
					current_line = create_sauce_line(area)

				var p = current_line.to_local(global_position)
				var r = p.distance_to(Vector2.ZERO)
				var direction = -p.direction_to(Vector2.ZERO)

				var collider: CollisionShape2D = area.get_node("CollisionShape2D")

				r = min(r, collider.shape.radius * collider.global_scale.x)

				current_line.add_point(r * direction)
	else:
		current_line = null
	
	if is_back_home():
		if not left:
			async_grace_check()
		else:
			held_handler.holding = false
			get_parent().show_self()
			queue_free()

func async_grace_check() -> void:
	await get_tree().create_timer(0.5).timeout
	
	if not is_back_home():
		left = true
	
	
