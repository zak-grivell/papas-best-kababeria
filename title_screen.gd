extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(start)
	


func start():
	get_tree().change_scene_to_file("res://day_scene.tscn")
