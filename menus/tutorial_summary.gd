extends Control
## Summary for all unlocked tutorials 

## Corresponding label index to the action in InputMap
const TUTORIAL_ACTION_LABEL_INDEXES: Dictionary = {
	"jump": [0, 2, 4, 5],
	"move_left": [1],
	"move_right": [1],
	"grapple": [6],
	"finger": [7],
}

@onready var tutorial_container: VBoxContainer = %TutorialContainer
@onready var close_button: SoundTextureButton = %CloseButton

var _current_index: int = 0


func _ready() -> void:
	_show_tutorials()
	SignalBus.sig_player_spawned.connect(_on_player_spawned)
	SignalBus.sig_key_remapped.connect(_on_key_remapped)
	close_button.pressed.connect(_on_close_button_pressed)
	visibility_changed.connect(_on_visibility_changed)


func _show_tutorials() -> void:
	if _current_index == 0:
		_hide_all_tutorials()
		tutorial_container.get_child(_current_index).show()
	elif _current_index > 7:
		printerr("Current tutorial summary index is larger than defined")
	else:
		_hide_all_tutorials()
		for i in _current_index + 1:
			if i == 0:
				tutorial_container.get_child(i).hide()
			else:
				tutorial_container.get_child(i).show()


func _update_tutorial_texts(index: int) -> void:
	var tutorial_label: Label = tutorial_container.get_child(index)
	Global.set_tutorial_label(tutorial_label, index)


func _hide_all_tutorials() -> void:
	for label in tutorial_container.get_children():
		label.hide()


func _on_player_spawned(level: int) -> void:
	_current_index = level


func _on_key_remapped(action: StringName) -> void:
	for index in TUTORIAL_ACTION_LABEL_INDEXES[action]:
		var label: Label = tutorial_container.get_child(index)
		Global.set_tutorial_label(label, index, action)


func _on_close_button_pressed() -> void:
	hide()


func _on_visibility_changed() -> void:
	if visible:
		_show_tutorials()
