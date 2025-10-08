extends CanvasLayer

@onready var game_timer: Label = %GameTimer
@onready var level_finished_window: Control = %LevelFinishedWindow
@onready var top_row_container: HBoxContainer = %TopRowContainer
@onready var pause_button: SoundButton = %PauseButton


func _ready():
	level_finished_window.hide()
	top_row_container.hide()
	SignalBus.sig_game_started.connect(_on_game_started)
	pause_button.pressed.connect(_on_pause_button_pressed)


func _on_node_2d_time_updated(time: float) -> void:
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	game_timer.text = "%02d:%05.2f" % [minutes, seconds]


func _on_game_started() -> void:
	top_row_container.show()


func _on_pause_button_pressed() -> void:
	SignalBus.sig_pause_menu_requested.emit()
