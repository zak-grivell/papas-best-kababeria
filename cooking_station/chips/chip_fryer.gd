extends "res://drop_zone.gd"

@export var potato: PackedScene
var current_item
var new_potato
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	accepts.append("potato")

func _on_item_dropped(item: Node) -> void:
	current_item = item
	current_item.visible = false
	new_potato = potato.instantiate()
	get_tree().root.add_child(new_potato)
	new_potato.global_position = Vector2(26, 534)
	new_potato.scale = Vector2(0.85, 0.771)
	await get_tree().create_timer(20).timeout
	current_item.item_type = "fries"
	current_item.texture = load("fries.png")
	current_item.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
