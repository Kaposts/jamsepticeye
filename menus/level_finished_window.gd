extends Control

@onready var time_label: Label = %TimeLabel
@onready var name_line_edit: LineEdit = %NameLineEdit
@onready var submit_button: SoundButton = %SubmitButton
@onready var menu_button: SoundButton = %MenuButton


var time: float = 0


func _ready():
	SignalBus.sig_level_finished.connect(_on_sig_level_finished)


func _on_sig_level_finished():
	time = get_tree().get_first_node_in_group("level").level_time
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	time_label.text = "Time: %02d:%05.2f" % [minutes, seconds]
	
	$VictorySFXPlayer.play_random()
	show()

func _on_submit_pressed() -> void:
	time = get_tree().get_first_node_in_group("level").level_time
	Leaderboard.add_score(name_line_edit.text, time)
	submit_button.disabled = true


func _on_close_pressed() -> void:
	hide()


func _on_menu_pressed() -> void:
	get_tree().reload_current_scene()
