extends Control

@export var customer: PackedScene

var day = true
var queue_1: Array = []
var queue_2: Array = []
var queue_1_start = Vector2(500, 750)
var queue_2_start = Vector2(1000, 350)
var spacing = 300
var n = 0

func _ready():
	_next_customer()

#func _update_queue_positions():
	#print("hi")
	#for i in range(queue_1.size()):
		#print(i)
		#queue_1[i].set_target(queue_1_start + Vector2(i * spacing, 0))
	#for i in range(queue_2.size()):
		#queue_2[i].set_target(queue_2_start + Vector2(i * spacing, 0))

#func move_to_second_queue(customer_given):
	#customer_given.position = Vector2(2*1075, 2*200)
	#if customer_given in queue_1:
		#queue_1.erase(customer_given)
		#queue_2.append(customer_given)
	#_update_queue_positions()

func update_first_row_pos():
	var tween = create_tween();

	for i in range(queue_1.size()):
		var c = queue_1[i]

		var mag = abs((queue_1_start.x + i * spacing * 1) - c.position.x)

		tween.tween_property(c, "position", queue_1_start + i * spacing * Vector2(1,0), mag / 1000).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.play()
	
	if queue_1.size() > 0:
		queue_1[0].can_take_order = true

	await tween.finished

func update_second_row_pos():
	var tween = create_tween();

	for i in range(queue_2.size()):
		var c = queue_2[i]

		var mag = abs((queue_2_start.x + i * spacing * 1) - c.position.x)

		tween.tween_property(c, "position", queue_2_start + i * spacing * Vector2(1,0), max(mag / 5000, 0.2)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.play()

	if GlobalState.all_orders_recived and queue_2.size() == 0 and queue_1.size() == 0:
		GlobalState.everyone_served =  true

	await tween.finished

func order_completed(node: Node2D):
	queue_2.erase(node)

	print("queue 1 size: ", queue_1.size(), " queue 2 size: ", queue_2.size(), GlobalState.all_orders_recived)

	update_first_row_pos()
	update_second_row_pos()

func move_to_second_queue(node: Node2D):
	queue_1.erase(node)
	queue_2.append(node)
	update_first_row_pos()
	update_second_row_pos()

func _next_customer():
	var new_customer: Node2D = customer.instantiate()
	new_customer.global_position = Vector2(2500, queue_1_start.x)

	queue_1.append(new_customer)

	update_first_row_pos()

	add_child(new_customer)
	var num = randi_range(GlobalState.interval_low, GlobalState.interval_high)
	n += 1
	if n >= GlobalState.number_of_customers:
		GlobalState.all_orders_recived = true
		return
	await get_tree().create_timer(num).timeout
	_next_customer()
	
