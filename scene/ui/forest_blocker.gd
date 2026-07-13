extends StaticBody2D

@onready var collision = $CollisionShape2D

func _ready() -> void:
    AreaManager.area_unlocked.connect(_on_area_unlocked)
    for area in AreaManager.unlocked_areas.keys():
        AreaManager.area_unlocked.emit(area)

    if AreaManager.is_area_unlocked("forest"):
        collision.disabled = true


func _on_area_unlocked(area_id: String) -> void:
    if area_id == "forest":
        collision.disabled = true
