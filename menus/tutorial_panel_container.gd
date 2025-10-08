extends PanelContainer
## Tutorial Panel Container Script
## Display text as tutorials as player progress through the game

@export var animation_duration: float = 1.0

@onready var close_button: SoundTextureButton = %CloseButton
@onready var tutorial_label: Label = %TutorialLabel
@onready var timer: Timer = $Timer

var _current_index: int = 0
var _tween: Tween


func _ready() -> void:
	hide()
	
	SignalBus.sig_game_started.connect(_on_game_started)
	SignalBus.sig_key_remapped.connect(_on_key_remapped)
	SignalBus.sig_player_spawned.connect(_on_player_spawned)
	close_button.pressed.connect(_on_close_button)
	timer.timeout.connect(_on_tiner_timeout)


## Set the text inside the tutorial labels for all the action from the InputMap
func _set_action_input_texts(index: int) -> void:
	if not Global.set_tutorial_label(tutorial_label, index):
		hide()


func _show_tutorial() -> void:
	_set_action_input_texts(_current_index)
	show()
	close_button.disabled = false
	timer.stop()
	
	modulate.a = 0.0
	
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.set_parallel()
	_tween.tween_property(self, "modulate", Color.WHITE, animation_duration)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	
	await _tween.finished
	timer.start()


func _close() -> void:
	_tween = create_tween()
	_tween.set_parallel()
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, animation_duration/2)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_QUART)
	
	await _tween.finished
	hide()


func _on_close_button() -> void:
	_close()
	close_button.disabled = true


func _on_game_started() -> void:
	_current_index = 0
	await get_tree().create_timer(5.0, false).timeout
	_show_tutorial()


func _on_key_remapped(action: StringName) -> void:
	Global.set_tutorial_label(tutorial_label, _current_index, action)


func _on_player_spawned(level: int) -> void:
	_current_index = level
	_show_tutorial()


func _on_tiner_timeout() -> void:
	_close()
