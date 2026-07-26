extends Camera2D

# The minimum and maximum zoom levels
@export var min_zoom: Vector2 = Vector2(0.5, 0.5)
@export var max_zoom: Vector2 = Vector2(4.0, 4.0)

# How fast the camera zooms in and out
@export var zoom_speed: float = 0.1

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

func zoom_in() -> void:
	# Vector2.clamp() ensures we don't zoom in past our max_zoom limit
	zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(min_zoom, max_zoom)

func zoom_out() -> void:
	# Vector2.clamp() ensures we don't zoom out past our min_zoom limit
	zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(min_zoom, max_zoom)
