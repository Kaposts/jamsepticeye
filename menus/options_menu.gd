extends Control

@onready var close_button: TextureButton =%CloseButton
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer
@onready var key_bindings_button: SoundTextureButton = %KeyBindingsButton

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var voice_slider: HSlider = %VoiceSlider
@onready var subtitle_check_box: SoundCheckBox = %SubtitleCheckBox
@onready var tutorial_check_box: SoundCheckBox = %TutorialCheckBox

@onready var keybinds_settings: Control = %KeybindsSettings

var is_animating: bool = false:
	set(flag):
		is_animating = flag
		if is_animating:
			disable_ui()


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	key_bindings_button.pressed.connect(_on_key_bindings_button_pressed)
	visibility_changed.connect(_on_visibility_changed)
	
	master_slider.value_changed.connect(_on_audio_slider_changed.bind("Master"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind("Music"))
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	voice_slider.value_changed.connect(_on_audio_slider_changed.bind("Voice"))
	subtitle_check_box.toggled.connect(_on_subtitle_toggled)
	tutorial_check_box.toggled.connect(_on_tutorial_toggled)
	
	update_display()
	enable_ui()
	keybinds_settings.hide()
	
	$ScrollBase.hide()


func update_display() -> void:
	master_slider.value = get_bus_volume_percent("Master")
	music_slider.value = get_bus_volume_percent("Music")
	sfx_slider.value = get_bus_volume_percent("SFX")
	voice_slider.value = get_bus_volume_percent("Voice")
	subtitle_check_box.button_pressed = VoiceLinesManager.subtitle_enabled
	tutorial_check_box.button_pressed = Global.tutorial_enabled


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
	key_bindings_button.disabled = false


func disable_ui() -> void:
	master_slider.editable = false
	sfx_slider.editable = false
	music_slider.editable = false
	voice_slider.editable = false
	close_button.disabled = true
	key_bindings_button.disabled = true


func _on_close_button_pressed() -> void:
	close()


func _on_key_bindings_button_pressed() -> void:
	keybinds_settings.show()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)


func _on_visibility_changed() -> void:
	if visible:
		update_display()


func _on_subtitle_toggled(toggled_on: bool) -> void:
	VoiceLinesManager.subtitle_enabled = toggled_on
	subtitle_check_box.text = "ON" if toggled_on else "OFF"


func _on_tutorial_toggled(toggled_on: bool) -> void:
	Global.tutorial_enabled = toggled_on
	tutorial_check_box.text = "ON" if toggled_on else "OFF"
	SignalBus.sig_tutorial_display_toggled.emit(toggled_on)
