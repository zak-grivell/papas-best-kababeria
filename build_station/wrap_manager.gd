extends Node2D

var wrap_spots = [150, 450, 750, 1050]
var wraps = [null, null, null, null]

func next_avaible_spot()  -> int:
	for i in range(wraps.size() - 1, -1, -1):
		if wraps[i] == null:
			return i
	
	return -1
			
func delete_wrap(node):
	for i in wraps.size():
		if wraps[i] == node:
			wraps[i] = null
			return

func spawn_new_wrap(current_wrap):
	var spot
	if current_wrap:
		spot = next_avaible_spot()
	
		if spot == -1:
			return
		
		wraps[spot] = current_wrap
		
	var next_wrap = load("res://build_station/wrap.tscn").instantiate()
	next_wrap.position = Vector2(-250, 600)
	add_child(next_wrap)
	
		
	var tween := create_tween()
	tween.set_parallel()
	
	tween.tween_property(next_wrap, "position", Vector2(250, 600), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if current_wrap:
		tween.tween_property(current_wrap, "position", Vector2(wrap_spots[spot], 1000), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.play()
	
