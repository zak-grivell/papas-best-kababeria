extends TabBar

@export var tab_container: TabContainer

func _ready():
	tab_count = tab_container.get_child_count()

	#for i in range(tab_container.get_child_count()):
		#set_tab_title(i, tab_container.get_child(i).name)

	tab_selected.connect(_on_tab_selected)
	tab_container.tab_changed.connect(_on_container_tab_changed)

func _on_tab_selected(tab_index: int) -> void:
	tab_container.current_tab = tab_index

func _on_container_tab_changed(tab_index: int) -> void:
	current_tab = tab_index
	_update_cameras(tab_index)

func _update_cameras(active_index: int) -> void:
	for i in range(get_tab_count()):
		var tab_scene = tab_container.get_tab_control(i)
		if tab_scene == null:
			continue

		var camera: Camera2D = tab_scene.get_node_or_null("Camera2D") # or "Camera3D"
		if camera:
			camera.enabled = (i == active_index)
	
