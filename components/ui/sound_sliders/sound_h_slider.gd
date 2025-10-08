class_name SoundHSlider
extends HSlider
## A HSlider with sound effects

const RANDOM_AUDIO_PLAYER: PackedScene = preload(Global.SCENE_PATHS.random_audio_player_component)

var hover_sfx_player: RandomAudioPlayer
var drag_sfx_player: RandomAudioPlayer


func _ready() -> void:
	hover_sfx_player = RANDOM_AUDIO_PLAYER.instantiate()
	add_child(hover_sfx_player)
	hover_sfx_player.streams.append(load(Global.ASSET_PATHS.button_hover))
	
	drag_sfx_player = RANDOM_AUDIO_PLAYER.instantiate()
	add_child(drag_sfx_player)
	drag_sfx_player.streams.append(load(Global.ASSET_PATHS.button_pressed))
	
	mouse_entered.connect(_on_mouse_entered)
	drag_started.connect(_on_drag_started)
	drag_ended.connect(_on_drag_ended)


func _on_mouse_entered() -> void:
	hover_sfx_player.play_random()


func _on_drag_started() -> void:
	drag_sfx_player.play_random()


func _on_drag_ended(modified: bool) -> void:
	if modified:
		drag_sfx_player.play_random()
