extends Area2D

enum State { TopBar, MainOrder }

@onready var done_button = get_node("/root/Node/UI Layer/DoneButton")

@onready var shape = $CollisionShape2D
var order: Order

var picked_up = false

var last_position = null
var last_scale = null
var offset = null

var state = State.MainOrder

func update_order(new_order):
	order = new_order
	await get_tree().process_frame

	render_with_object()

func render_with_object():
	$CookedToppings/Items.clear()
	$Toppings/Items.clear()
	$Sauce/Items.clear()
	
	for cooked_topping in order.cooked_topings:
		$CookedToppings/Items.add_icon_item(load("res://cooking_station/assets/{0}.png".format([
			"Chips"
		])))
		
	for topping in order.toppings:
		$Toppings/Items.add_icon_item(load("res://build_station/Assets/Toppings/{0}.png".format(
			[Order.get_enum_name(order.Toppings, topping)]
		)))
		
	for sauce in order.sauces:
		$Sauce/Items.add_icon_item(load("res://build_station/Assets/Sauces/{0}_top.png".format(
			[Order.get_enum_name(order.Sauce, sauce)]
		)))
	
	for child in $Drink.get_children():
		$Drink.remove_child(child)
		child.queue_free()
		
	var beer: Area2D = load("res://drinks_station/{0}.tscn".format(
		[Order.get_enum_name(order.Pint,order.pint)]
	)).instantiate()
	
	$Drink.add_child(beer)
	
	var beer_shape = beer.get_node("CollisionShape2D");
	
	beer.get_node("BeerMask").render_drink(1, order.head_wanted)
	
	beer.rotation_degrees = 0
	beer.position.x = $Drink.size.x / 2.0
	beer.scale *= 0.3
	beer.position.y = ($Drink.size.y - beer_shape.shape.extents.y * 2 * beer_shape.global_scale.y) / 2
	beer.input_pickable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if picked_up:
		global_position = get_global_mouse_position() - offset
		
		
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			picked_up = false
			
			for area in get_overlapping_areas():
				if area.name == "TopBar":
					if state == State.MainOrder:
						done_button.current_order = null
					
					scale = Vector2(0.25, 0.25)
					position = Vector2(get_global_mouse_position().x, 110)
					state = State.TopBar
					return
				elif area.name == "MainOrder":
					position = area.position
					done_button.current_order = self
					scale = Vector2(1, 1)
					state = State.MainOrder
					return
				
			global_position = last_position
			scale = last_scale
		
		
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	var is_pressed: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	
	
	if is_pressed:
		picked_up = true
		last_position = global_position 
		last_scale = scale
		offset = get_local_mouse_position()
		scale = Vector2(1,1)
