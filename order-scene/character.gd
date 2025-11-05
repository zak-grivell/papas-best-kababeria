extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

@onready var done_button = get_node("/root/Node/UI Layer/DoneButton")

@onready var order = load("res://orders/order_item.tscn")
@export var textures: Array[CompressedTexture2D]

var order_goto = Vector2(1800.0, 552.0)

var can_take_order: bool = false

var order_taken
var order_details = []

@export var move_speed: float = 100.0
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = textures[randi() % textures.size()]
	order_taken = false
	# position = Vector2(1070, 390)
	sprite.scale = Vector2(0.336, 0.3)
	order_details = _get_order()

func _get_order() -> Order:
	var cooked_toppings = Order.rand_from_enum(Order.CookedToppings, randi_range(1, 2))
	var new_toppings = Order.rand_from_enum(Order.Toppings, randi_range(2, 6))
	var sauces = Order.rand_from_enum(Order.Sauce, randi_range(0, 3))
	var pint = Order.rand_from_enum(Order.Pint, 1)[0]

	return Order.new(
		cooked_toppings,
		new_toppings,
		sauces,
		pint,
		randf_range(0, 0.5),
		self
	)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and can_take_order and done_button.current_order == null:
		var new_order = order.instantiate()

		get_node("/root/Node/UI Layer").add_child(new_order)

		new_order.position = order_goto

		new_order.update_order(order_details)
		
		done_button.current_order = new_order
		order_taken = true
			
		get_parent().move_to_second_queue(self)
					
