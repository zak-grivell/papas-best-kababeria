extends Area2D

@export var accepts: Array[String] = []
@export var zone_id: String = ""  
signal item_dropped(body)
signal item_picked(body)
signal item_returned(body)

func _ready() -> void:
	add_to_group("drop_zones")
