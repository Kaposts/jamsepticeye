extends PanelContainer
## Tutorial Panel Container Script
## Display text as tutorials as player progress through the game

@export var animation_duration: float = 1.0

@onready var close_button: SoundTextureButton = %CloseButton
@onready var tutorial_label: Label = %TutorialLabel

var _current_index: int = 0


const tutorial_texts: Array[String] = [
	"Press [%s] to flop and flip",
	"Press [%s] to move left and [%s] to move right",
	"Press [%s] to jump",
	"Move towards stone blocks to push them",
	"Automatically hangs on walls. Press [%s] to wall jump",
	"Hold [%s] in the air to hover",
	"Press [%s] to tongue-grapple to a fly",
	"Press [%s] key to BIG jump from a wall"
]


func _ready() -> void:
	hide()
	
	SignalBus.sig_game_started.connect(_on_game_started)
	SignalBus.sig_key_remapped.connect(_on_key_remapped)
	SignalBus.sig_player_spawned.connect(_on_player_spawned)
	close_button.pressed.connect(_on_close_button)


## Set the text inside the tutorial labels for all the action from the InputMap
func _set_action_input_texts(index: int) -> void:
	match index:
		0, 2, 4, 5: 
			tutorial_label.text = tutorial_texts[index]  % InputMap.action_get_events("jump")[0].as_text().trim_suffix(" (Physical)")
		1:
			tutorial_label.text = tutorial_texts[index] % [
				InputMap.action_get_events("move_left")[0].as_text().trim_suffix(" (Physical)"),
				InputMap.action_get_events("move_right")[0].as_text().trim_suffix(" (Physical)"),]
		6:
			tutorial_label.text = tutorial_texts[index] % InputMap.action_get_events("grapple")[0].as_text().trim_suffix(" (Physical)")
		7:
			tutorial_label.text = tutorial_texts[index] % InputMap.action_get_events("finger")[0].as_text().trim_suffix(" (Physical)")
		_:
			printerr("Trying to display an undefined tutorial text")
			hide()


func _show_tutorial() -> void:
	_set_action_input_texts(_current_index)
	show()
	
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.WHITE, animation_duration)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)


func _on_close_button() -> void:
	hide()


func _on_game_started() -> void:
	_current_index = 0
	await get_tree().create_timer(5.0, false).timeout
	_show_tutorial()


func _on_key_remapped(action: StringName) -> void:
	match action:
		"jump":
			match _current_index:
				0, 2, 4, 5: _set_action_input_texts(_current_index)
		"move_left", "move_right":
			if _current_index == 1: _set_action_input_texts(1)
		"grapple":
			if _current_index == 6: _set_action_input_texts(6)
		"finger":
			if _current_index == 7: _set_action_input_texts(7)


func _on_player_spawned(level: int) -> void:
	_current_index = level
	_show_tutorial()
