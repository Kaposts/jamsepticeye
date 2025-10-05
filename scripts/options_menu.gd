extends CanvasLayer

signal back_pressed

@onready var sfx_slider = %SfxSlider
@onready var music_slider = %MusicSlider
@onready var window_button: Button = %WindowButton


func _ready() -> void:
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("SFX"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	update_display()


func update_display() -> void:
	sfx_slider.value = get_bus_volume_percent("SFX")
	music_slider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_window_button_pressed() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	update_display()


func on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)


func on_back_pressed() -> void:
	back_pressed.emit()
