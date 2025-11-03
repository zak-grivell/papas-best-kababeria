extends Area2D

@export var bottle: CompressedTexture2D
@export var top: CompressedTexture2D
@export var sauce_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = top


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	var is_pressed: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT

	if is_pressed:
		$Sprite2D.visible = false
		
		var b = load("res://build_station/held_bottle.tscn").instantiate()
		
		b.get_node("Sprite2D").texture = bottle
		
		b.color = sauce_color
				
		add_child(b)


func show_self():
	$Sprite2D.visible = true
