extends Node
## Voice Lines Manager and Player autoload node


const UNLOCK_SUBTITLE: String = "LabelUnlock"
const BACKGROUND_SUBTITLE: String = "LabelBackground"

@export var ability_unlock_lines: Array[AudioStream]
@export var background_narration: Array[AudioStream]
@export var subtitle_animation_duration: float = 2.0

var subtitle_enabled: bool = true:
	set(flag):
		subtitle_enabled = flag
		if Global.game_started:
			dialogue_layer.visible = subtitle_enabled

var _background_narration_index: int = 0

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var between_narration_timer: Timer = $BetweenNarrationTimer
@onready var text_container: MarginContainer = %TextContainer
@onready var dialogue_layer: CanvasLayer = $DialogueLayer
@onready var dialogue_visible_timer: Timer = $DialogueVisibleTimer
@onready var game_start_dialogue_timer: Timer = $GameStartDialogueTimer


func _ready() -> void:
	dialogue_layer.hide()
	
	SignalBus.sig_game_started.connect(_on_game_started)
	SignalBus.sig_player_spawned.connect(_on_player_spawned)
	SignalBus.sig_game_restarted.connect(_on_game_restarted)
	
	between_narration_timer.timeout.connect(_on_narration_timer_timeout)
	dialogue_visible_timer.timeout.connect(_on_dialogue_timer_timeout)
	game_start_dialogue_timer.timeout.connect(_on_game_start_timer_timeout)
	
	audio.finished.connect(_on_audio_finished)


func _display_text(prefix: String, index: int) -> void:
	var label: Label = text_container.find_child(prefix + "%d" % index)
	label.visible_ratio = 0.0
	label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	_hide_all_labels()
	label.show()
	
	var tween = create_tween()
	var audio_length: float = audio.stream.get_length()
	if audio_length >= subtitle_animation_duration:
		tween.tween_property(label, "visible_ratio", 1.0, subtitle_animation_duration)
	else:
		tween.tween_property(label, "visible_ratio", 1.0, audio_length)
	
	if subtitle_enabled:
		dialogue_layer.show()
	else:
		dialogue_layer.hide()


func _hide_all_labels() -> void:
	for label in text_container.get_children():
		label.hide()


func _on_game_started() -> void:
	game_start_dialogue_timer.start()


func _on_player_spawned(level: int) -> void:
	dialogue_visible_timer.stop()
	between_narration_timer.stop()
	if level == 0 or level > 7:
		return
	
	if level < 7:
		audio.stream = ability_unlock_lines[level]
		_display_text(UNLOCK_SUBTITLE, level)
		audio.play()
	elif level == 7:
		_display_text(UNLOCK_SUBTITLE, level)
		dialogue_visible_timer.start(18.0)
		between_narration_timer.start()


func _on_narration_timer_timeout() -> void:
	dialogue_visible_timer.stop()
	if _background_narration_index >= background_narration.size()\
	or audio.playing:
		return
	
	audio.stream = background_narration[_background_narration_index]
	audio.play()
	_display_text(BACKGROUND_SUBTITLE, _background_narration_index)
	_background_narration_index += 1


func _on_dialogue_timer_timeout() -> void:
	dialogue_layer.hide()


func _on_game_restarted() -> void:
	dialogue_layer.hide()
	audio.stop()
	
	between_narration_timer.stop()
	dialogue_visible_timer.stop()
	game_start_dialogue_timer.stop()
	
	_background_narration_index = 0


func _on_audio_finished() -> void:
	dialogue_visible_timer.start()
	between_narration_timer.start()


func _on_game_start_timer_timeout() -> void:
	if not Global.game_started:
		return
	audio.stream = ability_unlock_lines[0]
	audio.play()
	_display_text(UNLOCK_SUBTITLE, 0)
