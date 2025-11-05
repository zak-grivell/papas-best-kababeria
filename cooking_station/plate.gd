extends "res://cooking_station/drop_zone.gd"

var current_item

var num = 0

@onready var reciver = get_node("/root/Node/TabContainer/Build Station/CookedToppingReciver")

enum State { COOKING, ASSEMBLY }

var state = State.COOKING

var dragging_items = false
var og_pos = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	connect("item_picked", _on_item_picked)
	connect("item_returned", _on_item_returned)
	
	self.input_event.connect(_on_input_event)
	
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
	
func _on_input_event(_viewport, event, _shape_idx):
	if state != State.ASSEMBLY:
		return

	var pressed = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if pressed:
		# print("detecting pressed")
		dragging_items = true
		og_pos = global_position
		
		var sprite_pos = $Sprite2D.global_position
		global_position = get_global_mouse_position()
		$Sprite2D.global_position = sprite_pos
		
			
			
func _process(_delta: float) -> void:
	if state != State.ASSEMBLY:
		return
		
	if dragging_items:
		var sprite_pos = $Sprite2D.global_position
		global_position = get_global_mouse_position()
		$Sprite2D.global_position = sprite_pos
		
	
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging_items = false
			on_place()
		
					
func on_place():
	for area in get_overlapping_areas():
		# print(area)
		if area.is_in_group("spawned_wraps"):
			# print("area found")
			for cooked in get_cooked_items():
				var p = cooked.global_position
				var s = cooked.global_scale
				remove_child(cooked)
				area.add_child(cooked)
				cooked.global_position = p
				cooked.global_scale = s
				
			var tween := create_tween()
			
			tween.tween_property(self, "global_position", Vector2(-300, global_position.y), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
			tween.finished.connect(func (): queue_free())

			return	
				
	var sprite_pos = $Sprite2D.global_position
	global_position = og_pos
	$Sprite2D.global_position = sprite_pos
				
func get_cooked_items():
	for c in get_children():
		print(c.name, ": ", c.get_groups())
	
	print("g: ",  get_children().filter(func (child): child.is_in_group("cooked_topping")))
	return get_children().filter(func (child): return child is Draggable and child.item_type in ["pork", "chicken", "beef", "lamb", "fries"])

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
	 	
	state = State.ASSEMBLY
		
	for child: Draggable in get_cooked_items():
		child.disabled = true
		child.monitorable = false
		child.monitoring = false
