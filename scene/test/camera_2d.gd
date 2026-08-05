extends Camera2D

# The minimum and maximum zoom levels
@export var min_zoom: Vector2 = Vector2(1, 1)
@export var max_zoom: Vector2 = Vector2(3.0, 3.0)

# How fast the camera zooms in and out
@export var zoom_speed: float = 0.1
@onready var tilemap: TileMapLayer = $"../../tilemap/ground"


func _ready():
    var rect = tilemap.get_used_rect()
    var tile_size = tilemap.tile_set.tile_size

    limit_left = rect.position.x * tile_size.x
    limit_top = rect.position.y * tile_size.y
    limit_right = (rect.position.x + rect.size.x) * tile_size.x
    limit_bottom = (rect.position.y + rect.size.y) * tile_size.y
    
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
