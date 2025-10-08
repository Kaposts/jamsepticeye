extends CanvasLayer

@onready var time_panel_container: PanelContainer = %TimePanelContainer
@onready var game_timer: Label = %GameTimer
@onready var level_finished_window: Control = %LevelFinishedWindow

func _ready():
	level_finished_window.hide()
	time_panel_container.hide()
	SignalBus.sig_game_started.connect(_on_game_started)


func _on_node_2d_time_updated(time: float) -> void:
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	game_timer.text = "%02d:%05.2f" % [minutes, seconds]


func _on_game_started() -> void:
	time_panel_container.show()
