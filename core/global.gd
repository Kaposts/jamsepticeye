extends Node

const SCENE_PATHS: Dictionary[StringName, String] = {
	"random_audio_player_component" : "uid://yey23xnr0h7w",
	
}


const ASSET_PATHS: Dictionary[StringName, StringName] = {
	"button_hover" : "uid://dsohwmrdb15vg",
	"button_pressed" : "uid://bfgkgyiaspngk",
	
}


const TUTORIAL_TEXTS: Array[String] = [
	"Press [%s] to flop and flip\n[ESC] and [Joypad MENU] to pause",
	"Use [%s] to move left and [%s] to move right",
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
					format_readable_input(InputMap.action_get_events("jump")[0])
			_:
				return false
		1: match action:
			"", "move_left", "move_right":
				label.text = Global.TUTORIAL_TEXTS[index] % [
					format_readable_input(InputMap.action_get_events("move_left")[0]),
					format_readable_input(InputMap.action_get_events("move_right")[0])]
			_:
				return false
		3:
			label.text = Global.TUTORIAL_TEXTS[index]
		6: match action:
			"", "grapple":
				label.text = Global.TUTORIAL_TEXTS[index] %\
					format_readable_input(InputMap.action_get_events("grapple")[0])
			_:
				return false
		7: match action:
			"", "finger":
				label.text = Global.TUTORIAL_TEXTS[index] %\
					format_readable_input(InputMap.action_get_events("finger")[0])
			_:
				return false
		_:
			printerr("Trying to set an undefined tutorial text")
			return false
	
	return true


## Return the event as text in human readable format. Return an empty string if event is invalid.
func format_readable_input(event: InputEvent) -> String:
	if event is InputEventKey:
		return event.as_text().trim_suffix(" (Physical)")
	elif event is InputEventJoypadButton:
		var words: PackedStringArray = event.as_text().split(" ", true, 3)
		return words[0] + " " + words[1] + " " + words[2]
	elif event is InputEventJoypadMotion:
		var words: PackedStringArray = event.as_text().get_slice("(", 1).split(" ", false, 2)
		var direction: float = event.as_text().get_slice("Value ", 1).to_float()
		var readable: String = words[0].split("", true, 1)[0] + "-" + words[1] + " "\
								+ ("Left" if direction < 0 else "Right")
		return readable
	elif event is InputEventMouseButton:
		return event.as_text()
	
	return ""


func _on_sig_game_paused():
	get_tree().paused = true
func _on_sig_game_unpaused():
	get_tree().paused = false
