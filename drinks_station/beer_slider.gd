extends VSlider


var close_sound: AudioStream = preload("res://sounds/Game Jame SFX_Beer Tap Close09.wav")
var open_sound: AudioStream = preload("res://sounds/Game Jame SFX_Beer Tap Open08.wav")

var close_player = AudioStreamPlayer.new()
var open_player = AudioStreamPlayer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_player.stream = close_sound
	open_player.stream = open_sound
	
	add_child(close_player)
	add_child(open_player)
	
	value_changed.connect(_on_slider_value_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_slider_value_changed(value):
	if value == 0:
		open_player.stop()
		open_player.play()
	elif value == 1:
		close_player.stop()
		close_player.play()
	
