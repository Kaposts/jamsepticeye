extends Node

const INPUT_ACTION_JUMP = "jump"

func _ready():
	SignalBus.sig_game_paused.connect(_on_sig_game_paused)
	SignalBus.sig_game_unpaused.connect(_on_sig_game_unpaused)

func _on_sig_game_paused():
	get_tree().paused = true
func _on_sig_game_unpaused():
	get_tree().paused = false
