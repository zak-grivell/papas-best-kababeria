extends TextureButton

enum Direction { UP, DOWN}

@export var camera: Camera2D
@export var direction: Direction

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
		var tween := create_tween()
		tween.set_parallel()
		var move_to
		match direction:
			Direction.UP:
				move_to = Vector2(0, 0)
			Direction.DOWN:
				move_to = Vector2(0, camera.bottom_offset)
		
		tween.tween_property(camera, "offset", move_to, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.play()
