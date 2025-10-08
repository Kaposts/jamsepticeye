class_name SoundTextureButton
extends TextureButton
## A texture button with sound effects

const RANDOM_AUDIO_PLAYER: PackedScene = preload(Global.SCENE_PATHS.random_audio_player_component)

var hover_sfx_player: RandomAudioPlayer
var pressed_sfx_player: RandomAudioPlayer


func _ready() -> void:
	hover_sfx_player = RANDOM_AUDIO_PLAYER.instantiate()
	add_child(hover_sfx_player)
	hover_sfx_player.streams.append(load(Global.ASSET_PATHS.button_hover))
	
	pressed_sfx_player = RANDOM_AUDIO_PLAYER.instantiate()
	add_child(pressed_sfx_player)
	pressed_sfx_player.streams.append(load(Global.ASSET_PATHS.button_pressed))
	
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	if not disabled:
		hover_sfx_player.play_random()


func _on_pressed() -> void:
	pressed_sfx_player.play_random()
