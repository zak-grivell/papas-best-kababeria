extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var order: PackedScene

var new_order
var order_taken
var order_details = []
var meat_to_add
var topping_to_add
var drink_to_add
var queue_manager: Node = null
var meats = ["pork", "beef", "lamb", "chicken"]
var toppings = ["fries", "chili_sauce", "ketchup", "mayo", "yogurt", "chili", "cabbage", "cucumber", "lettuce", "onion", "tomato"]
var drinks = ["irn_bru", "west", "tennants", "belhaven"]

@export var move_speed: float = 100.0
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order_taken = false
	position = Vector2(1070, 390)
	sprite.scale = Vector2(0.336, 0.3)
	order_details = _get_order()

func _get_order() -> Array:
	var meat_amounts = randi_range(1, 4)
	for i in range(meat_amounts):
		meat_to_add = randi_range(0, 3)
		order_details.append(meats[meat_to_add])
	var toppings_amounts = randi_range(0, 5)
	for i in range(toppings_amounts):
		topping_to_add = randi_range(0, 10)
		order_details.append(toppings[topping_to_add])
	var drinks_amounts = randi_range(0, 2)
	for i in range(drinks_amounts):
		drink_to_add = randi_range(0, 3)
		order_details.append(drinks[drink_to_add])
	print(order_details)
	return order_details

func _physics_process(delta: float) -> void:
	_move_towards_target(delta)
func _move_towards_target(delta: float) -> void:
	var direction = (target_position - global_position).normalized()
	var distance = global_position.distance_to(target_position)
	if distance > 5:
		velocity = direction * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide() 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if sprite and sprite.texture:
				var tex_size = sprite.texture.get_size() * sprite.scale
				var rect = Rect2(global_position - tex_size * 0.5, tex_size)
				if rect.has_point(event.position):
					new_order = order.instantiate()
					get_tree().root.add_child(new_order)
					new_order.global_position = Vector2(200, 200)
					#new_order.scale = Vector2(1.5, 1.5)
					#new_order.order_details = order_details
					print(new_order,order_details)
					order_taken = true
					if queue_manager:
						queue_manager.move_to_second_queue(self)

func set_target(pos: Vector2) -> void:
	target_position = pos
	print("boo")
	print(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
