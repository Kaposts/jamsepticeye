extends Control

@onready var close_button: TextureButton = $Options/Back_Button
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer
@onready var keybinding_button : TextureButton = $Options/KeyBindings

@onready var master_slider: HSlider = $Options/GridContainer/MasterSlider
@onready var music_slider: HSlider = $Options/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $Options/GridContainer/SFXSlider
@onready var voice_slider: HSlider = $Options/GridContainer/VoiceSlider

@onready var keybinds_settings: Control = $Options/KeybindsSettings

var is_animating: bool = false:
	set(flag):
		is_animating = flag
		if is_animating:
			disable_ui()


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	keybinding_button.pressed.connect(_on_keybinding_button_pressed)
	
	master_slider.value_changed.connect(_on_audio_slider_changed.bind("Master"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind("Music"))
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	voice_slider.value_changed.connect(_on_audio_slider_changed.bind("Voice"))
	
	update_display()
	enable_ui()
	keybinds_settings.hide()


func update_display() -> void:
	master_slider.value = get_bus_volume_percent("Master")
	music_slider.value = get_bus_volume_percent("Music")
	sfx_slider.value = get_bus_volume_percent("SFX")
	voice_slider.value = get_bus_volume_percent("Voice")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func close() -> void:
	is_animating = true
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	await get_tree().create_timer(1.0).timeout
	is_animating = false
	hide()


func enable_ui() -> void:
	master_slider.editable = true
	sfx_slider.editable = true
	music_slider.editable = true
	voice_slider.editable = true
	close_button.disabled = false
	keybinding_button.disabled = false


func disable_ui() -> void:
	master_slider.editable = false
	sfx_slider.editable = false
	music_slider.editable = false
	voice_slider.editable = false
	close_button.disabled = true
	keybinding_button.disabled = true


func _on_close_button_pressed() -> void:
	close()


func _on_keybinding_button_pressed() -> void:
	keybinds_settings.show()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)
