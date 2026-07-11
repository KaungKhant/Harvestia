extends CanvasLayer

@onready var slider = $HSlider

func _ready():

	slider.value = 100

func _on_h_slider_value_changed(value):

	var music_bus = AudioServer.get_bus_index("Music")

	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value / 100.0))

	var sfx_bus = AudioServer.get_bus_index("SFX")

	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value / 100.0))
