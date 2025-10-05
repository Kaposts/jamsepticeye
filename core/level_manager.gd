extends Node2D

var level_time: float = 0.0
var is_running: bool = false

signal time_updated(time: float)
signal level_finished(final_time: float)

func _ready():
	start_timer()
	SignalBus.sig_level_finished.connect(_on_sig_level_finished)

func start_timer():
	level_time = 0.0
	is_running = true

func stop_timer():
	is_running = false
	emit_signal("level_finished", level_time)

func reset_timer():
	level_time = 0.0
	is_running = false

func _process(delta: float) -> void:
	if is_running:
		level_time += delta
		emit_signal("time_updated", level_time)

func _on_sig_level_finished():
	stop_timer()