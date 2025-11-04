extends "res://drop_zone.gd"

var current_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	connect("item_dropped", Callable(self, "_on_item_dropped"))
	accepts.append("fries")
	accepts.append("lamb")
	accepts.append("beef")
	accepts.append("chicken")
	accepts.append("pork")

func _on_item_dropped(item: Node) -> void:
	current_item = item

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
