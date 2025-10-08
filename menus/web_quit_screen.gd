extends CanvasLayer
## Web quite screen
## Handles quit request on web page

var _previous_audio: float = 0.0

@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_menu: TextureButton = %MainMenu


func _ready() -> void:
	get_tree().paused = true
	_mute_audio()
	main_menu.pressed.connect(_on_main_menu_pressed)
	
	scroll_anim.play("Scroll_Open")
	animation_player.play("appear")
	
	await animation_player.animation_finished
	main_menu.disabled = false


func _mute_audio() -> void:
	_previous_audio = _get_master_bus_volume_percent()
	_set_master_bus_volume_percent(0.0)


func _reset_audio() -> void:
	_set_master_bus_volume_percent(_previous_audio)


func _get_master_bus_volume_percent() -> float:
	var bus_index = AudioServer.get_bus_index("Master")
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func _set_master_bus_volume_percent(percent: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_main_menu_pressed() -> void:
	main_menu.disabled = true
	scroll_anim.play("Scroll_Close")
	animation_player.play_backwards("appear")
	
	await animation_player.animation_finished
	get_tree().paused = false
	_reset_audio()
	get_tree().reload_current_scene()
