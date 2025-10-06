extends Node
## Voice Lines Manager and Player autoload node


const UNLOCK_SUBTITLE: String = "LabelUnlock"
const BACKGROUND_SUBTITLE: String = "LabelBackground"

@export var ability_unlock_lines: Array[AudioStream]
@export var background_narration: Array[AudioStream]

var _background_narration_index: int = 0

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var after_unlock_narration_timer: Timer = $AfterUnlockNarrationTimer
@onready var between_narration_timer: Timer = $BetweenNarrationTimer
@onready var text_container: MarginContainer = %TextContainer
@onready var dialogue_layer: CanvasLayer = $DialogueLayer
@onready var dialogue_visible_timer: Timer = $DialogueVisibleTimer


func _ready() -> void:
	dialogue_layer.hide()
	
	SignalBus.sig_game_started.connect(_on_game_started)
	SignalBus.player_spawned.connect(_on_player_spawned)
	
	after_unlock_narration_timer.timeout.connect(_on_timer_timeout)
	between_narration_timer.timeout.connect(_on_timer_timeout)
	dialogue_visible_timer.timeout.connect(_on_dialogue_timer_timeout)


func _display_text(prefix: String, index: int) -> void:
	dialogue_layer.show()
	
	var label: Label = text_container.find_child(prefix + "%d" % index)
	label.visible_ratio = 0.0
	label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	_hide_all_labels()
	label.show()
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 3.0)


func _hide_all_labels() -> void:
	for label in text_container.get_children():
		label.hide()


func _on_game_started() -> void:
	audio.stream = ability_unlock_lines[0]
	audio.play()
	_display_text(UNLOCK_SUBTITLE, 0)
	
	await audio.finished
	dialogue_visible_timer.start()


func _on_player_spawned(level: int) -> void:
	after_unlock_narration_timer.stop()
	dialogue_visible_timer.stop()
	if level == 0 or level > 7:
		return
	
	if level < 7:
		audio.stream = ability_unlock_lines[level]
		_display_text(UNLOCK_SUBTITLE, level)
		audio.play()
	elif level == 7:
		_display_text(UNLOCK_SUBTITLE, level)
	
	await audio.finished
	if _background_narration_index < background_narration.size():
		after_unlock_narration_timer.start()
		between_narration_timer.stop()
	
	dialogue_visible_timer.start()


func _on_timer_timeout() -> void:
	dialogue_visible_timer.stop()
	if _background_narration_index >= background_narration.size():
		return
	
	audio.stream = background_narration[_background_narration_index]
	audio.play()
	_display_text(BACKGROUND_SUBTITLE, _background_narration_index)
	_background_narration_index += 1
	
	await audio.finished
	dialogue_layer.hide()
	between_narration_timer.start()


func _on_dialogue_timer_timeout() -> void:
	dialogue_layer.hide()
