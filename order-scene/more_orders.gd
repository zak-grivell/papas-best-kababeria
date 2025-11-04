extends Node2D

@export var customer: PackedScene

var day = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
extends Node2D

@export var customer_scene: PackedScene
var queue_1: Array = []
var queue_2: Array = []
var queue_1_start = Vector2(370, 420)
var queue_2_start = Vector2(1070, 600)
var spacing = 100

func _ready():
	while day == true:
		_next_customer()

func _update_queue_positions():
	for i in range(queue_1.size()):
		queue_1[i].set_target(queue_1_start + Vector2(0, i * spacing))
	for i in range(queue_2.size()):
		queue_2[i].set_target(queue_2_start + Vector2(0, i * spacing))

func move_to_second_queue(customer):
	if customer in queue_1:
		queue_1.erase(customer)
		queue_2.append(customer)
	_update_queue_positions()

func _next_customer():
	var num = randi_range(3, 9)
	await get_tree().create_timer(num).timeout
	var new_customer = customer.instantiate()
	add_child(new_customer)
	queue_1.append(new_customer)
	customer.queue_manager = self
	_update_queue_positions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
