extends Node2D

@export var positions: Array[Vector2]

var toppings = [null, null, null]


func next_avaible_spot() -> int:
	for i in range(toppings.size() - 1, -1, -1):
		if toppings[i] == null:
			return i
	
	return -1
			
func delete_wrap(node):
	for i in toppings.size():
		if toppings[i] == node:
			toppings[i] = null
			return
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# print(get_path())
	
func send(node: Area2D):
	# print("sent", next_avaible_spot())
	add_child(node)
	
	var spot = next_avaible_spot()
	
	if spot == -1:
		return
		
	node.position = positions[spot]
	
	# print(node.position, positions[spot])
		
	toppings[spot] = node
