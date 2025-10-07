extends PanelContainer
## Tutorial Panel Container Script
## Display text as tutorials as player progress through the game

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var close_button: SoundTextureButton = %CloseButton
@onready var text_container: PanelContainer = %TextContainer
@onready var tutorial_label: Label = %TutorialLabel


const tutorial_texts: Array[String] = [
	"Press %s to flop and flip",
	"Press %s and %s to move",
]


func _ready() -> void:
	_set_action_input_texts(1)
	
	SignalBus.sig_game_started.connect(_on_game_started)
	close_button.pressed.connect(_on_close_button)


## Set the text inside the tutorial labels for all the action from the InputMap
func _set_action_input_texts(index: int) -> void:
	match index:
		0: 
			tutorial_label.text = tutorial_texts[index] % InputMap.action_get_events("jump")[0].as_text().trim_suffix(" (Physical)")
		1:
			tutorial_label.text = tutorial_texts[index] % [
				InputMap.action_get_events("move_left")[0].as_text().trim_suffix(" (Physical)"),
				InputMap.action_get_events("move_right")[0].as_text().trim_suffix(" (Physical)"),]
				
	
	# make global signal to update key rebind while tutorial text is visible


func _hide_all_tutorials() -> void:
	for label in text_container.get_children():
		label.hide()


func _on_close_button() -> void:
	hide()


func _on_game_started() -> void:
	_set_action_input_texts(1)
	animation_player.play("appear")
