extends Control

var callback = null

func _ready() -> void:
	# print(get_path())
	$Button.pressed.connect(_on_button_pressed)

func show_finished_screen(beer_rank: float, kebab_rank: float, sprite: CompressedTexture2D, new_callback: Callable):
	callback = new_callback 

	if GlobalState.everyone_served:
		$Button.text = "Finish Day!"
	else:
		$Button.text = "Continue"

	$CharacterBody2D/Sprite2D.texture = sprite

	# Modulate from red (0) -> orange (0.5) -> green (1) based on beer_rank * kebab_rank
	var t: float = clamp((beer_rank + kebab_rank) / 2, 0.0, 1.0)
	var red := Color(1, 0, 0)
	var orange := Color(1, 0.5, 0)
	var green := Color(0, 1, 0)
	var col: Color
	if t <= 0.5:
		col = red.lerp(orange, t / 0.5)
	else:
		col = orange.lerp(green, (t - 0.5) / 0.5)
	$TextureRect.modulate = col

	$"Drink Score".text = "Beer Rank: " + str(round(beer_rank * 100.0)) + "%"
	$"Kebab Score".text = "Kebab Rank: " + str(round(kebab_rank * 100.0)) + "%"
	$"Overall Score".text = "Overall Rank: " + str(round((beer_rank + kebab_rank) * 50.0)) + "%"
	

	visible = true

func _on_button_pressed():
	if GlobalState.everyone_served:
		GlobalState.next_day()
		get_tree().change_scene_to_file("res://day_scene.tscn")
	else:
		visible = false
		callback.call()
