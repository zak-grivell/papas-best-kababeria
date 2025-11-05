extends TextureButton

@onready var customer_container = get_node("/root/Node/TabContainer/Order Station")
@onready var popup = get_node("/root/Node/UI Layer/OrderFinishedPopup")

@export var current_drink = null:
	set(value):
		current_drink = value
		check_ready()
		
	get:
		return current_drink

@export var current_kebab = null:
	set(value):
		current_kebab = value
		check_ready()
		
	get:
		return current_kebab

@export var current_order = null:
	set(value):
		current_order = value
		check_ready()
	get:
		return current_order

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_click)

func on_click():
	if current_drink == null or current_kebab == null or current_order == null:
		return
		
	var ranks = current_order.order.rank(current_kebab, current_drink)

	customer_container.order_completed(current_order.order.person)
	
	var sprite = current_order.order.person.get_node("Sprite2D").texture

	current_order.order.person.queue_free()

	popup.show_finished_screen(
		ranks.beer, 
		ranks.kebab, 
		sprite, 
	func():
		current_order.queue_free()
		current_order = null

		current_drink.queue_free()
		current_drink = null

		current_kebab.queue_free()
		current_kebab = null
	)		
		
func check_ready():
	# print(current_drink, current_kebab)
	disabled = current_drink == null or current_kebab == null or current_order == null
