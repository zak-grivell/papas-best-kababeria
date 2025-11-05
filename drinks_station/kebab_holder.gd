extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_path())

@export var current_serve = null

var positions = [1225, 1375, 1525]
var boxes = [null, null, null]

func next_avaible_spot()  -> int:
	for i in range(boxes.size() - 1, -1, -1):
		if boxes[i] == null:
			return i
	
	return -1
			
func delete_wrap(node):
	for i in boxes.size():
		if boxes[i] == node:
			boxes[i] = null
			return

func check_avaliable() -> bool:
	return next_avaible_spot() != -1

func send_box(box: Node2D):
	self.add_child(box)
		
	var spot = next_avaible_spot()
	
	if spot == -1:
		print("wtf man")
		return
		
	
	box.global_position = Vector2(positions[spot], 800)
	box.rotation_degrees = 90
	box.scale = Vector2(0.5, 0.5)
	boxes[spot] = box
