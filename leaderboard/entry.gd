extends HBoxContainer

@onready var name_label = $name
@onready var score_label = $score

var entry_name: String
var score: float

func _ready():
	name_label.text = " "+entry_name

	var minutes = int(score / 60)
	var seconds = fmod(score, 60.0)
	score_label.text = "%02d:%05.2f" % [minutes, seconds]
