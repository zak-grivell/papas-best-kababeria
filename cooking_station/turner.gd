extends "res://cooking_station/drop_zone.gd"

@export var lamb: PackedScene
@export var pork: PackedScene
@export var beef: PackedScene
@export var chicken: PackedScene
@export var uncooked_pork: PackedScene
@export var uncooked_lamb: PackedScene
@export var uncooked_chicken: PackedScene
@export var uncooked_beef: PackedScene
@onready var sprite: Sprite2D = $Sprite2D


const TIME = 5

var current_item
var type
var new_meat
var click_count = 0
var size = null
var angle = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	accepts.append("lamb_uncooked")
	accepts.append("beef_uncooked")
	accepts.append("chicken_uncooked")
	accepts.append("pork_uncooked")

func _on_item_dropped(item: Draggable) -> String:
	print(item.item_type, "            ", current_item)
	
	if current_item != null:
		current_item.queue_free()
		sprite.texture = load("res://turner.png")
		type = ""
		size = null
		angle = null
	current_item = item

	current_item.visible = false
	if current_item.item_type == "lamb_uncooked":
		type = "lamb_uncooked"
		_spawn_meat(item.start_position)
		sprite.texture = load("res://cooking_station/assets/lamb_wait.png")
		sprite.scale = Vector2(0.55, 0.55)
		await get_tree().create_timer(TIME).timeout
		sprite.texture = load("res://cooking_station/assets/lamb_ready.png")
		sprite.scale = Vector2(0.55, 0.55)
		type = "lamb"
	elif current_item.item_type == "beef_uncooked":
		type = "beef_uncooked"
		_spawn_meat(item.start_position)
		sprite.texture = load("res://cooking_station/assets/beef_wait.png")
		sprite.scale = Vector2(0.55, 0.55)
		await get_tree().create_timer(TIME).timeout
		sprite.texture = load("res://cooking_station/assets/beef_ready.png")
		sprite.scale = Vector2(0.55, 0.55)
		type = "beef"
	elif current_item.item_type == "chicken_uncooked":
		type = "chicken_uncooked"
		_spawn_meat(item.start_position)
		sprite.texture = load("res://cooking_station/assets/chicken_wait.png")
		sprite.scale = Vector2(0.55, 0.55)
		await get_tree().create_timer(TIME).timeout
		sprite.texture = load("res://cooking_station/assets/chicken_ready.png")
		sprite.scale = Vector2(0.55, 0.55)
		type = "chicken"
	elif current_item.item_type == "pork_uncooked":
		type = "pork_uncooked"
		_spawn_meat(item.start_position)
		sprite.texture = load("res://cooking_station/assets/pork_wait.png")
		sprite.scale = Vector2(0.55, 0.55)
		await get_tree().create_timer(TIME).timeout
		sprite.texture = load("res://cooking_station/assets/pork_ready.png")
		sprite.scale = Vector2(0.55, 0.55)
		type = "pork"
	return type


#function to click on meat turner and create meat piles
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		print("detected", click_count)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_spawn_meat(event.position)


func _spawn_meat(spawn_position: Vector2):
	if type in ["pork", "chicken", "beef", "lamb", "lamb_uncooked", "beef_uncooked", "chicken_uncooked", "pork_uncooked"]:
		if type == "lamb":
			new_meat = lamb.instantiate()
		elif type == "beef":
			new_meat = beef.instantiate()
		elif type == "chicken":
			new_meat = chicken.instantiate()
		elif type == "pork":
			new_meat = pork.instantiate()
		elif type == "lamb_uncooked":
			new_meat = uncooked_lamb.instantiate()
			angle = 33.4
		elif type == "beef_uncooked":
			new_meat = uncooked_beef.instantiate()
			angle = -40.8
		elif type == "pork_uncooked":
			new_meat = uncooked_pork.instantiate()
			angle = 33.4
		else:
			new_meat = uncooked_chicken.instantiate()
			angle = 40.8
		get_tree().root.add_child(new_meat)
		new_meat.global_position = spawn_position
		new_meat.delete_on_not_found = true
		if size != null:
			new_meat.rotation_degrees = angle
			new_meat.scale = size
