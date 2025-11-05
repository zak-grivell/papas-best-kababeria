extends Node

var day := 1
var all_orders_recived := false
var everyone_served := false

var interval_low:
	get():
		return clamp(30 - (day - 1) * 5, 10, 30)

var interval_high:
	get():
		return clamp(60 - (day - 1) * 10, 20, 60)

var number_of_customers:
	get():
		return clamp(1 + (day - 1) * 2, 1, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func next_day():
	day += 1
	all_orders_recived = false
	everyone_served = false
