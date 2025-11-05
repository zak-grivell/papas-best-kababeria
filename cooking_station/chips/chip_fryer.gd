extends "res://cooking_station/drop_zone.gd"

@export var potato: PackedScene
var current_item
var new_potato
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	accepts.append("potato")

func _on_item_dropped(item: Draggable) -> void:
	current_item = item
	new_potato = potato.instantiate()
	get_parent().add_child(new_potato)
	new_potato.global_position = item.start_position
	$AudioStreamPlayer.play()
	await get_tree().create_timer(20).timeout
	$AudioStreamPlayer.stop()
	current_item.item_type = "fries"
	current_item.get_node("Sprite2D").texture = load("res://cooking_station/assets/fries.png")
	current_item.add_to_group("cooked_topping")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
