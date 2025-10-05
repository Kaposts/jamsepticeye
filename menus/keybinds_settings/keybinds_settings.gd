extends Control
## Keybinds Settings Menu

@export var input_button: PackedScene
@onready var action_list: VBoxContainer = %ActionList
@onready var reset_button: Button = %ResetButton


var is_remapping: bool = false
var action_to_map: StringName = ""
var remapping_button = null


var input_actions: Dictionary[StringName, StringName] = {
	"move_left" : "Move Left",
	"move_right" : "Move Right",
	"jump" : "Jump",
	"grapple" : "Tongue Hook",
	"finger" : "BIG Jump",
}


func _ready() -> void:
	_create_action_list()
	
	reset_button.pressed.connect(_on_reset_button_pressed)


func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.is_pressed()):
			# Turen double click into single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_map)
			InputMap.action_add_event(action_to_map, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_map = ""
			remapping_button = null
			
			accept_event()


func _create_action_list() -> void:
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button: Button = input_button.instantiate()
		var action_label: Label = button.find_child("LabelAction")
		var input_label: Label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		if not events.is_empty():
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _update_action_list(button: Button, event: InputEvent) -> void:
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_input_button_pressed(button: Button, action: StringName) -> void:
	if not is_remapping:
		is_remapping = true
		action_to_map = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."


func _on_reset_button_pressed() -> void:
	_create_action_list()
