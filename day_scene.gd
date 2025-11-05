extends Control


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#await get_tree().create_timer(5).timeout
	#get_tree().change_scene_to_file("res://main.tscn")

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_tree().change_scene_to_file("res://main.tscn")
