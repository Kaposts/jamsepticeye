extends CanvasLayer

@onready var game_timer: Label = %GameTimer

func _ready():
	%LevelFinishedWindow.hide()
	game_timer.hide()
	SignalBus.sig_game_started.connect(_on_game_started)


func _on_node_2d_time_updated(time: float) -> void:
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	game_timer.text = "%02d:%05.2f" % [minutes, seconds]


func _on_game_started() -> void:
	game_timer.show()
	#pass
