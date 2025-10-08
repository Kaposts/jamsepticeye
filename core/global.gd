extends Node

const SCENE_PATHS: Dictionary[StringName, String] = {
	"random_audio_player_component" : "uid://yey23xnr0h7w",
	
}


const ASSET_PATHS: Dictionary[StringName, StringName] = {
	"button_hover" : "uid://dsohwmrdb15vg",
	"button_pressed" : "uid://bfgkgyiaspngk",
	
}


const TUTORIAL_TEXTS: Array[String] = [
	"Press [%s] to flop and flip",
	"Press [%s] to move left and [%s] to move right",
	"Press [%s] to jump",
	"Move towards stone blocks to push them",
	"Automatically hangs on walls. Press [%s] to wall jump",
	"Hold [%s] in the air to hover",
	"Press [%s] to tongue-grapple to a fly",
	"Press [%s] key to BIG jump from a wall"
]


func _ready():
	SignalBus.sig_game_paused.connect(_on_sig_game_paused)
	SignalBus.sig_game_unpaused.connect(_on_sig_game_unpaused)


func set_tutorial_label(label: Label, index: int, action: StringName = "") -> bool:
	match index:
		0, 2, 4, 5: match action:
			"", "jump":
				label.text = Global.TUTORIAL_TEXTS[index] %\
					InputMap.action_get_events("jump")[0].as_text().trim_suffix(" (Physical)")
			_:
				return false
		1: match action:
			"", "move_left", "move_right":
				label.text = Global.TUTORIAL_TEXTS[index] % [
					InputMap.action_get_events("move_left")[0].as_text().trim_suffix(" (Physical)"),
					InputMap.action_get_events("move_right")[0].as_text().trim_suffix(" (Physical)"),]
			_:
				return false
		3:
			label.text = Global.TUTORIAL_TEXTS[index]
		6: match action:
			"", "grapple":
				label.text = Global.TUTORIAL_TEXTS[index] %\
					InputMap.action_get_events("grapple")[0].as_text().trim_suffix(" (Physical)")
			_:
				return false
		7: match action:
			"", "finger":
				label.text = Global.TUTORIAL_TEXTS[index] %\
					InputMap.action_get_events("finger")[0].as_text().trim_suffix(" (Physical)")
			_:
				return false
		_:
			printerr("Trying to set an undefined tutorial text")
			return false
	
	return true


func _on_sig_game_paused():
	get_tree().paused = true
func _on_sig_game_unpaused():
	get_tree().paused = false
