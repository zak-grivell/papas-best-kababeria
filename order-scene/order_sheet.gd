extends Node2D

@export var order_details: Array

var order_recieved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _check_order():
	order_details.sort()
	order_recieved.sort()
	if order_details == order_recieved:
		print("yay!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
