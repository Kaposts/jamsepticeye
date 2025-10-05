extends Node2D

signal time_updated(time: float)
signal level_finished(final_time: float)

var level_time: float = 0.0
var is_running: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	SignalBus.sig_game_started.connect(_on_game_started)
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


func _on_game_started() -> void:
	animation_player.play("game_start")
	await animation_player.animation_finished
	
	start_timer()
