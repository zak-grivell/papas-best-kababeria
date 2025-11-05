extends Control

@export var customer: PackedScene

var day = true
var queue_1: Array = []
var queue_2: Array = []
var queue_1_start = Vector2(370, 420)
var queue_2_start = Vector2(520, 195)
var spacing = 75

func _ready():
	_next_customer()

func _update_queue_positions():
	print("hi")
	for i in range(queue_1.size()):
		print(i)
		queue_1[i].set_target(queue_1_start + Vector2(i * spacing, 0))
	for i in range(queue_2.size()):
		queue_2[i].set_target(queue_2_start + Vector2(i * spacing, 0))

func move_to_second_queue(customer):
	customer.position = Vector2(1075, 200)
	if customer in queue_1:
		queue_1.erase(customer)
		queue_2.append(customer)
	_update_queue_positions()

func _next_customer():
	var num = randi_range(30, 90)
	await get_tree().create_timer(num).timeout
	var new_customer = customer.instantiate()
	get_tree().current_scene.add_child(new_customer)
	queue_1.append(new_customer)
	new_customer.queue_manager = self
	_update_queue_positions()
	_next_customer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
