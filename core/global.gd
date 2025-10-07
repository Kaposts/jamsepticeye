extends Node

const SCENE_PATHS: Dictionary[StringName, String] = {
	"random_audio_player_component" : "uid://yey23xnr0h7w",
	
}


const ASSET_PATHS: Dictionary[StringName, StringName] = {
	"button_hover" : "uid://dsohwmrdb15vg",
	"button_pressed" : "uid://bfgkgyiaspngk",
	
}


func _ready():
	SignalBus.sig_game_paused.connect(_on_sig_game_paused)
	SignalBus.sig_game_unpaused.connect(_on_sig_game_unpaused)

func _on_sig_game_paused():
	get_tree().paused = true
func _on_sig_game_unpaused():
	get_tree().paused = false
