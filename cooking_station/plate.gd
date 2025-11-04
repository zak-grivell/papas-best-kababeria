extends "res://cooking_station/drop_zone.gd"

var current_item

var num = 0

@onready var reciver = get_node("/root/Node/TabContainer/Build Station/CookedToppingReciver")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	connect("item_picked", _on_item_picked)
	connect("item_returned", _on_item_returned)
	
	$SendButton.input_event.connect(_on_click)
	
	accepts.append("fries")
	accepts.append("lamb")
	accepts.append("beef")
	accepts.append("chicken")
	accepts.append("pork")

func _on_item_dropped(item: Node2D) -> void:
	current_item = item
	
	var pos = item.global_position
	var s = item.global_scale
	
	item.get_parent().remove_child(item)
	self.add_child(item)
	
	item.global_position = pos
	item.global_scale = s
	
	num += 1
	check_button()

func _on_item_picked(item: Draggable) -> void:
	num -= 1
	check_button()
	

func _on_item_returned():
	num += 1
	check_button()
	
func check_button():
	$SendButton.visible = num > 0
	
func _on_click(_viewport, event, _shape_idx):
	var pressed = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if pressed:
		var tween := create_tween()
			
		tween.set_parallel()
			
		tween.tween_property(self, "position", Vector2(position.x, 1500), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		tween.play()
						
		tween.finished.connect(send_other_screen)
	
func send_other_screen():
	var pos = global_position
	
	self.get_node("Sprite2D").flip_h = true
	
	var dup = load("res://cooking_station/plate.tscn").instantiate()
	
	get_parent().add_child(dup)
	
	get_parent().remove_child(self)
	
	reciver.send(self)
	
	$SendButton.visible = false

	
	dup.global_position = pos
	
	var tween := create_tween()
		
	tween.tween_property(dup, "global_position", Vector2(pos.x, 1086.0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	 	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
