extends Control
## Keybinds Settings Menu


const KEY_BIND_PRESET_2: Dictionary[StringName, int] = {
	"move_left" : KEY_LEFT,
	"move_right" : KEY_RIGHT,
	"jump" : KEY_SPACE,
	"grapple" : KEY_F,
	"finger" : KEY_D,
}

const KEY_BIND_PRESET_3: Dictionary[StringName, int] = {
	"move_left" : KEY_A,
	"move_right" : KEY_D,
	"jump" : KEY_SPACE,
	"grapple" : MOUSE_BUTTON_LEFT,
	"finger" : MOUSE_BUTTON_RIGHT,
}


var INPUT_ACTIONS: Dictionary[StringName, StringName] = {
	"move_left" : "Move Left",
	"move_right" : "Move Right",
	"jump" : "Jump",
	"grapple" : "Tongue Hook",
	"finger" : "BIG Jump",
}

const ACTION_LABEL: String = "LabelAction"
const INPUT_LABEL: String = "LabelInput"

@export var input_button: PackedScene
@onready var action_list: VBoxContainer = %ActionList
@onready var preset_button_1: Button = %PresetButton1
@onready var preset_button_2: Button = %PresetButton2
@onready var preset_button_3: Button = %PresetButton3
@onready var back_button: Button = %BackButton
@onready var key_rebind_sfx_player: RandomAudioPlayer = $KeyRebindSFXPlayer


var is_remapping: bool = false
var action_to_map: StringName = ""
var remapping_button = null


func _ready() -> void:
	_create_action_list()
	
	preset_button_1.pressed.connect(_on_preset_button_pressed.bind(1))
	preset_button_2.pressed.connect(_on_preset_button_pressed.bind(2))
	preset_button_3.pressed.connect(_on_preset_button_pressed.bind(3))
	back_button.pressed.connect(_on_back_button_pressed)
	visibility_changed.connect(_on_visibility_changed)


func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey\
		or (event is InputEventMouseButton and event.is_pressed())\
		or event is InputEventJoypadButton:
			# Turns double click into single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_map)
			InputMap.action_add_event(action_to_map, event)
			_update_action_list(remapping_button, event)
			
			SignalBus.sig_key_remapped.emit(action_to_map)
			
			is_remapping = false
			action_to_map = ""
			remapping_button = null
			
			key_rebind_sfx_player.play_random()
			accept_event()


func _create_action_list() -> void:
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in INPUT_ACTIONS:
		var button: Button = input_button.instantiate()
		var action_label: Label = button.find_child(ACTION_LABEL)
		var input_label: Label = button.find_child(INPUT_LABEL)
		
		action_label.text = INPUT_ACTIONS[action]
		
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		if not events.is_empty():
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		SignalBus.sig_key_remapped.emit(action)


func _update_action_list(button: Button, event: InputEvent) -> void:
	var label: Label = button.find_child(INPUT_LABEL)
	
	if event is InputEventJoypadButton:
		var words: PackedStringArray = event.as_text().split(" ", true, 3)
		label.text = words[0] + " " + words[1] + " " + words[2]
	else:
		label.text = event.as_text().trim_suffix(" (Physical)")


func _update_current_input_map() -> void:
	for button in action_list.get_children():
		var action_label: Label = button.find_child(ACTION_LABEL)
		var input_label: Label = button.find_child(INPUT_LABEL)
		var action_name: StringName = INPUT_ACTIONS.find_key(action_label.text)
		var events: Array[InputEvent] = InputMap.action_get_events(action_name)
		input_label.text = events[0].as_text().trim_suffix(" (Physical)")


func _load_key_binds_preset(preset_index: int) -> void:
	# Loads from default project settings
	if preset_index == 1:
		_create_action_list()
		return
	
	var preset: Dictionary[StringName, int] = {}
	match preset_index:
		2: preset = KEY_BIND_PRESET_2
		3: preset = KEY_BIND_PRESET_3
		_:
			printerr("No key preset index found")
			return
	
	for action in INPUT_ACTIONS:
		# Loads preset keys or mouse buttons into a new InputEvent
		var new_event: InputEvent
		
		# If preset key is an unprintable ASCII decimal number (<32) aka invalid key binds,
		# assume it is from mouse button:
		if preset[action] < 32:
			new_event = InputEventMouseButton.new()
			new_event.button_index = preset[action]
		else:
			new_event = InputEventKey.new()
			new_event.physical_keycode = preset[action]
		
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, new_event)
		
		SignalBus.sig_key_remapped.emit(action)
	
	_update_current_input_map()


func _on_input_button_pressed(button: Button, action: StringName) -> void:
	if not is_remapping:
		is_remapping = true
		action_to_map = action
		remapping_button = button
		button.find_child(INPUT_LABEL).text = "Press any button or mouse to bind..."


func _on_back_button_pressed() -> void:
	hide()


func _on_visibility_changed() -> void:
	if visible:
		_update_current_input_map()


func _on_preset_button_pressed(index: int) -> void:
	_load_key_binds_preset(index)
