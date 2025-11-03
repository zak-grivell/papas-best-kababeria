extends Camera2D

@export var bottom_offset: int

func _ready() -> void:
	show_bottom()

func show_top():
	offset.y = 0
	
func show_bottom():
	offset.y = bottom_offset
