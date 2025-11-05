extends Area2D

enum State { Shelf, Pour }

var state = State.Shelf

@export var me: Resource

@export var head_portion: float = 0.0
@export var beer_procress: float = 0.0

@onready var done_button = get_node("/root/Node/UI Layer/DoneButton")

var head_amount = 0

@export var camera: Camera2D
@export var drink_tap: VSlider

@onready var drink: Node2D  = $BeerMask

@onready var knob: Area2D = $Knob
@onready var knob_collider: CollisionShape2D = $Knob/CollisionShape2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var slider_radius: float = collider.shape.size.y + 100

var in_current_slot = false

func _ready() -> void:
	knob.input_event.connect(_knob_input)
	
var dragging := false
var moving := false

func _process(delta: float) -> void:
	if state == State.Pour:
		render_beer(delta)
		
	if 	dragging:
		follow_rotation()
				
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging = false
			
			
	if moving:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			global_position = get_global_mouse_position()
		else:
			moving = false
			
			stopped_moving()
		
			
func stopped_moving():
	for area in get_overlapping_areas():
		# print(area.name)
		if area.name == "Sink":
			
			if in_current_slot:
				done_button.current_drink = null
			
			queue_free()
			
			return
		if area.name == "ServeHolder":
			scale /= Vector2(1.5, 1.5)
			in_current_slot = true
			position = Vector2(1275, 1200 - collider.shape.size.y * collider.global_scale.y)
			
			done_button.current_drink = self
			
			return
	
	drink_tap.editable = not in_current_slot
	drink_tap.visible = not in_current_slot
		
	knob.input_pickable = not in_current_slot
	knob.visible = not in_current_slot
	
	position = last_pos
	
func render_beer(delta: float):
	if drink_tap.value > 0.95:
		return
		
	var head_map := func (theta: float):
		return max(-0.57 * abs(theta) + 0.6,0)

	var delta_speed = delta * (1 - drink_tap.value) * min(1,2 ** (1-4 * beer_procress))
	
	if beer_procress < 0.99:
		head_portion = (beer_procress * head_portion + delta_speed * head_map.call(rotation)) /  (beer_procress+delta_speed)
	
	beer_procress = beer_procress+delta_speed
	
	drink.render_drink(min(1,beer_procress), head_portion)
	
	if beer_procress > 1.1:
		$Overflow.visible = true
	
	
var pos = null
var last_pos = null

func _input_event(_viewport, event, _shape_idx):
	var is_pressed: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT

	if is_pressed and state == State.Shelf and drink_tap.visible == false:
		pos = position
				
		var tween := create_tween()
		tween.set_parallel()
		tween.tween_property(camera, "offset", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		var transform_to = drink_tap.global_position

		transform_to.y += collider.shape.size.y * collider.global_scale.y  + 20

		tween.tween_property(self, "position", transform_to, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "rotation", 0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		tween.play()

		tween.finished.connect(start_pouring)
	elif is_pressed and state == State.Pour and drink_tap.value == 1 :
		moving = true
		
		rotation = 0
		
		last_pos = position
		
		drink_tap.editable = false
		drink_tap.visible = false
		
		knob.input_pickable = false
		knob.visible = false


func _knob_input(_viewport, event, _shape_idx):
	if state != State.Pour: return
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true


func start_pouring():
			
	var clone = me.instantiate()
		
	clone.position = pos
	clone.drink_tap = drink_tap
	clone.camera = camera
	clone.me = me
		
	get_parent().add_child(clone)
	
	drink_tap.editable = true
	drink_tap.visible = true
	
	state = State.Pour
	knob.input_pickable = true
	knob.visible = true
	update_knob_position()

var start_angle := -PI  / 3     # start of arc (left)
var end_angle := PI / 3

var mouse_vector = Vector2.ZERO

func follow_rotation():
	var mp = get_global_mouse_position()
	
	look_at(mp)
	rotate(-PI/2)
	
	rotation = clamp(rotation, -PI/3, PI/3)
	
func update_knob_position():
	var direction = Vector2.DOWN.rotated(rotation)
	var p = direction * slider_radius
	knob.position = p
