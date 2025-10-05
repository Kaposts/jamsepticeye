extends Control

var time: float = 0

func _ready():
	SignalBus.sig_level_finished.connect(_on_sig_level_finished)

func _on_sig_level_finished():
	time = get_tree().get_first_node_in_group("level").level_time
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	$time.text = "Time: %02d:%05.2f" % [minutes, seconds]

	show()

func _on_submit_pressed() -> void:
	time = get_tree().get_first_node_in_group("level").level_time
	Leaderboard.add_score($LineEdit.text, time)
	$submit.disabled = true
	SignalBus.sig_score_submitted.emit()


func _on_close_pressed() -> void:
	hide()


func _on_menu_pressed() -> void:
	pass # Replace with function body.
